import 'package:gomoney_finance_app/service/IsolateService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/GoogleHttpClient.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:permission_handler/permission_handler.dart' as per;

class BackupService {
  GoogleSignIn? sign;

  Future<BackupService> init() async {
    try {
      sign = GoogleSignIn(scopes: ['email', DriveApi.driveScope]);
      await sign!.signInSilently();
    } catch (e) {}
    return this;
  }

  Future connectBackup(context) async {
    bool isFileExists = false;
    per.Permission.storage.request();
    var client = GoogleHttpClient(await sign!.currentUser!.authHeaders);
    var driveApi = DriveApi(client);
    var fileList = await driveApi.files.list();
    List<File> files = fileList.files!;
    for (var file in files) {
      if (file.name == "backupGoMoney") {
        isFileExists = true;
        Media dwfile = await driveApi.files
            .get(file.id!, downloadOptions: DownloadOptions.fullMedia) as Media;
        List<int> dataStore = [];
        dwfile.stream.listen((data) {
          print("DataReceived: ${data.length}");
          dataStore.insertAll(dataStore.length, data);
        }, onDone: () {
          print("Task Done");
          String result = utf8.decode(dataStore);
          print(result);
          GetIt.I<SqliteService>().clearAllTables().then(
              (value) => {GetIt.I<SqliteService>().restoreBackup(result)});
          GetIt.I<PreferencesService>().setDateOfLastBackup(DateTime.now());
          GetIt.I<IsolateService>().followBackup();
          Navigator.pop(context);
        }, onError: (error) {
          print("Some Error");
        });
      }
    }
    if (!isFileExists) {
      var path = await getApplicationDocumentsDirectory();
      var backup =
          await GetIt.I<SqliteService>().generateBackup(isEncrypted: true);
      var file = io.File(path.path + "/backupGoMoney");
      if (await file.exists()) {
        await file.delete();
      }
      await file.create();
      await file.writeAsString(backup);
      await driveApi.files.create(File()..name = "backupGoMoney",
          uploadMedia: Media(file.openRead(), await file.length()));
      GetIt.I<PreferencesService>().setDateOfLastBackup(DateTime.now());
      Navigator.pop(context);
    }
  }
}
