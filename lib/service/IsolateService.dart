import 'dart:async';
import 'dart:isolate';
import 'dart:io' as io;
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/GoogleHttpClient.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:path_provider/path_provider.dart';

class IsolateService {
  FlutterIsolate? isol;
  Future<void> followBackup() async {
    if (isol != null) isol!.kill();
    ReceivePort receivePort = ReceivePort();

    List<dynamic> list = [receivePort.sendPort];
    isol = await FlutterIsolate.spawn(MyIsolates.backupIsolate, list);
    receivePort.listen((data) {
      if (data == 0) isol!.kill();
      if (data == 1)
        GetIt.I<PreferencesService>().setDateOfLastBackup(DateTime.now());
    });
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
}
