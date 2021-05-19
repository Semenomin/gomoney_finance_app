import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/screen/CurrentScanScreen.dart';
import 'package:gomoney_finance_app/screen/PhotoViewScreen.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ListViewElement extends StatelessWidget {
  final File image;
  final Scan scan;
  final DateFormat formatter = DateFormat('dd.MM.yyyy H:mm');

  ListViewElement({required this.image, required this.scan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: Row(
              children: [
                Container(
                  width: 110.r,
                  height: 120.r,
                  color: Colors.black,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotoViewScreen(Image.file(image))),
                        );
                      },
                      child: Image.file(image)),
                ),
                VerticalDivider(
                  width: 14.r,
                  color: Colors.transparent,
                ),
                Expanded(
                    child: GestureDetector(
                  onLongPress: () {
                    BotToast.showSimpleNotification(title: scan.name);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CurrentScanScreen(scan: scan)),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                scan.name,
                                style: TextStyle(
                                    color: StyleUtil.secondaryColor,
                                    fontSize: 15.r),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                (image.lengthSync() / 1000000)
                                        .toStringAsFixed(3) +
                                    " Мб",
                                style: TextStyle(
                                    color: StyleUtil.secondaryColor,
                                    fontSize: 15.r),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                formatter.format(DateTime.parse(
                                  image.lastModifiedSync().toString(),
                                )),
                                style: TextStyle(
                                    color: StyleUtil.secondaryColor,
                                    fontSize: 15.r),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  padding: EdgeInsets.only(top: 10.r),
                  child: GestureDetector(
                    onTap: () {
                      _fileSubMenu(context);
                    },
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/menu_dots.svg',
                          color: StyleUtil.secondaryColor,
                          fit: BoxFit.none,
                        )),
                  ),
                )
              ],
            ),
          )),
          Divider(
            thickness: 1,
            height: 1,
          )
        ],
      ),
    );
  }

  void _fileSubMenu(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: StyleUtil.secondaryColor),
                    child: Column(
                      children: [
                        ListTile(
                            onTap: () =>
                                AddName(context, "RENAME", (_nameController) {
                                  var box = Hive.box('myScan');
                                  box.put(image.path, _nameController.text);
                                  Navigator.pop(context);
                                }),
                            title: Text("Rename",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: StyleUtil.primaryColor,
                                ))),
                        Divider(height: 0),
                        ListTile(
                            onTap: () {
                              var box = Hive.box('myScan');
                              image.deleteSync();
                              box.delete(image.path);
                              Navigator.pop(context);
                            },
                            title: Text("Delete",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: StyleUtil.primaryColor,
                                ))),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget textForm(String hint, TextEditingController controller,
      TextInputType textType, Color color) {
    return Container(
      height: 65.r,
      constraints: BoxConstraints(maxWidth: 390.r),
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Theme(
        data: ThemeData(primaryColor: color, hintColor: color),
        child: TextFormField(
            controller: controller,
            keyboardType: textType,
            obscureText:
                textType == TextInputType.visiblePassword ? true : false,
            decoration: new InputDecoration(
              labelText: hint,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            style: TextStyle(
              fontSize: 15.r,
              fontFamily: "Prompt",
              color: color,
            )),
      ),
    );
  }
}
