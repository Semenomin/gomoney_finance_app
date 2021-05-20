import 'dart:async';
import 'dart:isolate';
import 'dart:io' as io;
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/Planned.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/GoogleHttpClient.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class IsolateService {
  FlutterIsolate? backupIsolate;
  FlutterIsolate? plannedIsolate;

  Future<void> followBackup() async {
    if (backupIsolate != null) backupIsolate!.kill();
    ReceivePort receivePort = ReceivePort();

    List<dynamic> list = [receivePort.sendPort];
    backupIsolate = await FlutterIsolate.spawn(MyIsolates.backupIsolate, list);
    receivePort.listen((data) {
      if (data == 0) backupIsolate!.kill();
      if (data == 1)
        GetIt.I<PreferencesService>().setDateOfLastBackup(DateTime.now());
    });
  }

  Future<void> followPlanned() async {
    if (backupIsolate != null) backupIsolate!.kill();
    ReceivePort receivePort = ReceivePort();

    List<dynamic> list = [receivePort.sendPort];
    backupIsolate = await FlutterIsolate.spawn(MyIsolates.plannedIsolate, list);
    receivePort.listen((data) {});
  }
}

class MyIsolates {
  static void backupIsolate(List<dynamic> message) async {
    GoogleSignInAccount? acc;
    PreferencesService service = await PreferencesService().init();
    Timer.periodic(Duration(seconds: 5), (timer) async {
      DateTime? date = service.getDateOfLastBackup();
      if (date != null) {
        GoogleSignIn _googleSignIn = GoogleSignIn(
          scopes: <String>[
            'email',
            DriveApi.driveScope,
          ],
        );
        acc = await _googleSignIn.signInSilently();
        if (acc != null) {
          date = DateTime(date.year, date.month, date.day, date.hour,
              date.minute + 1, date.second, date.millisecond, date.microsecond);
          if (date.microsecondsSinceEpoch <=
              DateTime.now().microsecondsSinceEpoch) {
            SqliteService ser = await SqliteService().init();
            var client = GoogleHttpClient(await acc!.authHeaders);
            var driveApi = DriveApi(client);
            var fileList = await driveApi.files.list();
            List<File> files = fileList.files!;
            for (var file in files) {
              if (file.name == "backupGoMoney") {
                await driveApi.files.delete(file.id!);
              }
            }
            var path = await getApplicationDocumentsDirectory();
            var backup = await ser.generateBackup(isEncrypted: true);
            var file = io.File(path.path + "/backupGoMoney");
            if (await file.exists()) {
              await file.delete();
            }
            await file.create();
            await file.writeAsString(backup);
            await driveApi.files.create(File()..name = "backupGoMoney",
                uploadMedia: Media(file.openRead(), await file.length()));
            service.setDateOfLastBackup(DateTime.now());
            message[0].send(1);
          }
        } else
          message[0].send(0);
      } else
        message[0].send(0);
    });
  }

  static void plannedIsolate(List<dynamic> message) async {
    SqliteService sqlite = SqliteService();
    Timer.periodic(Duration(seconds: 10), (timer) async {
      List<Planned> planned = await sqlite.getAllPlanned();
      if (planned.length != 0) {
        for (Planned plan in planned) {
          if (plan.dateTo.difference(DateTime.now()).inDays <= 0) {
            var nextDate = plan.dateFrom.add(
                Duration(days: plan.dateTo.difference(plan.dateFrom).inDays));
            plan.dateFrom = plan.dateTo;
            plan.dateTo = nextDate;
            sqlite.updatePlanned(plan);
            sqlite.addTransaction(FinTransaction(
                id: Uuid().v4(),
                name: "Planned " + plan.name,
                isIncome: plan.isIncome,
                date: DateTime.now(),
                amountOfMoney: plan.amountOfMoney));
          }
        }
      }
    });
  }
}
