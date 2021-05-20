import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/ScannerPage/ListViewElement.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: Hive.box("myScan").listenable(),
            builder: (context, Box box, widget) {
              return FutureBuilder(
                future: GetIt.I<SqliteService>().getScans(),
                builder: (context, AsyncSnapshot<List<Scan>?> snapshot) {
                  if (snapshot.hasData) {
                    for (var itemBox in box.keys) {
                      for (var itemSql in snapshot.data!) {
                        if (itemBox == itemSql.id) {
                          itemSql.path = box.get(itemBox);
                        }
                      }
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        padding: EdgeInsets.all(20.r),
                        itemBuilder: (context, index) {
                          return ListViewElement(
                            image: File(snapshot
                                .data![snapshot.data!.length - (index + 1)]
                                .path!),
                            scan: snapshot
                                .data![snapshot.data!.length - (index + 1)],
                          );
                        },
                      ),
                    );
                  } else
                    return Center(child: LoadingPage(StyleUtil.secondaryColor));
                },
              );
            },
          )),
          Divider(
            height: 0,
            thickness: 2,
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _openGallery,
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: StyleUtil.secondaryColor,
                              shape: BoxShape.circle),
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/gallery_icon.svg',
                            height: 18,
                            width: 18,
                            fit: BoxFit.none,
                            color: StyleUtil.primaryColor,
                          )),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.transparent,
                  width: 20,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _openCamera,
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: StyleUtil.secondaryColor,
                              shape: BoxShape.circle),
                          padding: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/photo_icon.svg',
                            height: 18.5,
                            width: 22,
                            fit: BoxFit.none,
                            color: StyleUtil.primaryColor,
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _openCamera() async {
    final photo =
        await picker.getImage(source: ImageSource.camera, imageQuality: 80);
    _scan(photo);
    setState(() {});
  }

  void _openGallery() async {
    final photo =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    _scan(photo);
    setState(() {});
  }

  void _scan(PickedFile? photo) async {
    if (photo != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: photo.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: StyleUtil.primaryColor,
              toolbarWidgetColor: Colors.white,
              statusBarColor: StyleUtil.secondaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        Uint8List _byte = await Cv2.threshold(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: croppedFile.path,
          thresholdValue: 130,
          maxThresholdValue: 200,
          thresholdType: Cv2.THRESH_BINARY,
        );
        Permission.storage.request();
        final result = await ImageGallerySaver.saveImage(_byte,
            quality: 80, name: Uuid().v4()) as Map;
        if (result["isSuccess"]) {
          AddName(context, "Add Name", (controller) async {
            var id = Uuid().v4();
            Hive.box("myScan").put(
              id,
              result['filePath']
                  .toString()
                  .substring(7, result['filePath'].length),
            );
            BotToast.showLoading();
            List<Object> list = await _getDescription(result['filePath']);
            Scan scan = Scan(
                id: id,
                name: controller.text,
                description: list[0] as String,
                transactionNum: list[1] as double,
                date: DateTime.now());
            await GetIt.I<SqliteService>().addScan(scan);
            Navigator.pop(context);
            BotToast.closeAllLoading();
            AreYouSure(context, "CREATE TRANSACTION?", () {}, scanId: scan.id);
          });
        }
        print(result);
      }
    }
  }

  Future<List<Object>> _getDescription(String path) async {
    List<Object> output = [];
    List<String> res = [];
    String text = await FlutterTesseractOcr.extractText(
        path.toString().substring(7, path.length),
        language: 'rus',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
          "OcrEngineMode": "OEM_TESSERACT_CUBE_COMBINED",
        });
    output.add(text);
    RegExp reg = RegExp(
      r".*С[УЧ]М.*\d",
      caseSensitive: false,
      multiLine: true,
    );
    RegExp reg1 = RegExp(
      r".*ИТОГ.*\d",
      caseSensitive: false,
      multiLine: true,
    );
    RegExp reg2 = RegExp(
      r".*БПК.*\d",
      caseSensitive: false,
      multiLine: true,
    );
    RegExp reg3 = RegExp(
      r".*карт.*\d",
      caseSensitive: false,
      multiLine: true,
    );
    String? sum = reg.stringMatch(text);
    String? itog = reg1.stringMatch(text);
    String? card = reg3.stringMatch(text);
    String? bpk = reg2.stringMatch(text);
    if (itog != null) {
      if (itog.contains(":")) {
        itog = itog.replaceAll(" ", "");
        itog = itog.split(":").last;
        itog = itog.substring(
            itog.indexOf(RegExp(r"\d")), itog.indexOf(RegExp(r"\d$")) + 1);
        res.add(itog);
      } else if (itog.contains("=")) {
        itog = itog.replaceAll(" ", "");
        itog = itog.split("=").last;
        itog = itog.substring(
            itog.indexOf(RegExp(r"\d")), itog.indexOf(RegExp(r"\d$")) + 1);
        res.add(itog);
      } else {
        itog = itog.substring(
            itog.indexOf(RegExp(r"\d")), itog.indexOf(RegExp(r"\d$")) + 1);
        res.add(itog.replaceAll(" ", ""));
      }
    }
    if (bpk != null) {
      if (bpk.contains(":")) {
        bpk = bpk.replaceAll(" ", "");
        bpk = bpk.split(":").last;
        bpk = bpk.substring(
            bpk.indexOf(RegExp(r"\d")), bpk.indexOf(RegExp(r"\d$")) + 1);
        res.add(bpk);
      } else if (bpk.contains("=")) {
        bpk = bpk.replaceAll(" ", "");
        bpk = bpk.split("=").last;
        bpk = bpk.substring(
            bpk.indexOf(RegExp(r"\d")), bpk.indexOf(RegExp(r"\d$")) + 1);
        res.add(bpk);
      } else {
        bpk = bpk.substring(
            bpk.indexOf(RegExp(r"\d")), bpk.indexOf(RegExp(r"\d$")) + 1);
        res.add(bpk.replaceAll(" ", ""));
      }
    }
    if (card != null) {
      if (card.contains(":")) {
        card = card.replaceAll(" ", "");
        card = card.split(":").last;
        card = card.substring(
            card.indexOf(RegExp(r"\d")), card.indexOf(RegExp(r"\d$")) + 1);
        res.add(card);
      } else if (card.contains("=")) {
        card = card.replaceAll(" ", "");
        card = card.split("=").last;
        card = card.substring(
            card.indexOf(RegExp(r"\d")), card.indexOf(RegExp(r"\d$")) + 1);
        res.add(card);
      } else {
        card = card.substring(
            card.indexOf(RegExp(r"\d")), card.indexOf(RegExp(r"\d$")) + 1);
        res.add(card.replaceAll(" ", ""));
      }
    }
    if (sum != null) {
      if (sum.contains(":")) {
        sum = sum.replaceAll(" ", "");
        sum = sum.split(":").last;
        sum = sum.substring(
            sum.indexOf(RegExp(r"\d")), sum.indexOf(RegExp(r"\d$")) + 1);
        res.add(sum);
      } else if (sum.contains("=")) {
        sum = sum.replaceAll(" ", "");
        sum = sum.split("=").last;
        sum = sum.substring(
            sum.indexOf(RegExp(r"\d")), sum.indexOf(RegExp(r"\d$")) + 1);
        res.add(sum);
      } else {
        sum = sum.substring(
            sum.indexOf(RegExp(r"\d")), sum.indexOf(RegExp(r"\d$")) + 1);
        res.add(sum.replaceAll(" ", ""));
      }
    }
    if (res.length != 0) {
      for (var item in res) {
        if (!item.contains(".")) {
          if (!item.contains(",")) {
            res[res.indexOf(item)] = "0.0";
          } else {
            res[res.indexOf(item)] = item.replaceAll(",", ".");
          }
        }
      }
      var resultNum;
      resultNum = double.tryParse(res[0]) ?? 0.0;
      for (var item in res) {
        if ((double.tryParse(item) ?? 0.0) >= resultNum) {
          resultNum = double.tryParse(item);
        }
      }
      output.add(resultNum);
    } else {
      output.add(0.0);
    }
    return output;
  }
}
