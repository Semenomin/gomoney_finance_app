import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/GoogleHttpClient.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:permission_handler/permission_handler.dart' as per;
import 'package:flutter_archive/flutter_archive.dart';

class Loading {
  Loading(context, title) {
    showMaterialModalBottomSheet(
      expand: true,
      enableDrag: false,
      context: context,
      builder: (context) => FutureBuilder(
        future: connectBackup(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Column(
                children: [
                  AppUtils.emptyContainer(double.infinity, 70.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: StyleUtil.secondaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            AppUtils.emptyContainer(double.infinity, 20.h),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text(title,
                                  style: TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 30.w,
                                      color: StyleUtil.primaryColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: LoadingPage(StyleUtil.primaryColor),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          } else
            return LoadingPage(StyleUtil.primaryColor);
        },
      ),
    );
  }
}

Future<void> connectBackup(context) async {
  bool isFileExists = false;
  per.Permission.storage.request();
  final googleSignIn = GoogleSignIn.standard(scopes: [DriveApi.driveScope]);
  final GoogleSignInAccount googleUser = (await googleSignIn.signIn())!;
  var client = GoogleHttpClient(await googleUser.authHeaders);
  var driveApi = DriveApi(client);
  var fileList = await driveApi.files.list();
  String dbDirectory =
      await getApplicationDocumentsDirectory().then((value) => value.path);
  var dir = io.Directory(dbDirectory + "/database");
  GetIt.I<SqliteService>().closeDb();
  List<File> files = fileList.files!;
  for (var file in files) {
    if (file.name == "dbGoMoney") {
      isFileExists = true;
      Media dwfile = await driveApi.files
          .get(file.id!, downloadOptions: DownloadOptions.fullMedia) as Media;
      final saveFile = io.File('$dbDirectory/${file.name}');
      List<int> dataStore = [];
      dwfile.stream.listen((data) {
        print("DataReceived: ${data.length}");
        dataStore.insertAll(dataStore.length, data);
      }, onDone: () {
        print("Task Done");
        saveFile.writeAsBytes(dataStore);
        unArchiveBackup(dir)
            ? print("File UnArchived")
            : print("UnArchive Error");
        Navigator.pop(context);
      }, onError: (error) {
        print("Some Error");
      });
    }
  }
  if (!isFileExists) archiveBackupAndSend(dir, driveApi,context);
}

bool unArchiveBackup(dir) {
  try {
    // final bytes = io.File(dir + "/dbGoMoney.zip").readAsBytesSync();
    // final archive = ZipDecoder().decodeBytes(bytes);
    // for (final file in archive) {
    //   final filename = file.name;
    //   if (file.isFile) {
    //     final data = file.content as List<int>;
    //     io.File(dir + "/" + filename)
    //       ..createSync(recursive: true)
    //       ..writeAsBytesSync(data);
    //   } else {
    //     io.Directory(dir + "/" + filename)..create(recursive: true);
    //   }
    // }
    // GetIt.I<SqliteService>().init();
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> archiveBackupAndSend(dir, DriveApi driveApi,context) async {
  try {
    final zipFile = io.File(
        await getApplicationDocumentsDirectory().then((value) => value.path) +
            "/dbGoMoney");
    await ZipFile.createFromDirectory(
        sourceDir: dir,
        zipFile: zipFile,
        includeBaseDirectory: true,
        recurseSubDirs: true);
    if (await zipFile.exists()) {
      await driveApi.files.create(File()..name = zipFile.path.split("/").last,
          uploadMedia: Media(zipFile.openRead(), await zipFile.length()));
    }
    Navigator.pop(context);
    return true;
  } catch (_) {
    return false;
  }
}
