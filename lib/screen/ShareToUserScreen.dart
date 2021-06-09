import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/model/Partner.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class ShareToUserScreen extends StatefulWidget {
  @override
  _ShareToUserState createState() => _ShareToUserState();
}

class _ShareToUserState extends State<ShareToUserScreen> {
  List<int> selectedIndexes = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: Future.wait([
            GetIt.I<SqliteService>().getAllPartners(),
            GetIt.I<SqliteService>().getAllMoneyBoxes(),
            GetIt.I<SqliteService>().getUserCategorys(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Object> res = [];
              for (List item in snapshot.data as List) {
                for (var elem in item) {
                  res.add(elem);
                }
              }
              return Container(
                color: StyleUtil.primaryColor,
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 60.r,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: double.infinity,
                                  width: 60.r,
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: StyleUtil.secondaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            generateQr(res);
                          },
                          child: Container(
                            height: 60.r,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: double.infinity,
                                  width: 60.r,
                                  child: FittedBox(
                                    child: Icon(
                                      LineIcons.qrcode,
                                      color: StyleUtil.secondaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: StyleUtil.rowndedBoxWithShadow
                            .copyWith(color: StyleUtil.secondaryColor),
                        child: ListView.builder(
                            itemCount: res.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () {
                                          if (selectedIndexes.length !=
                                              res.length) {
                                            List<int> list = [];
                                            for (var i = 1;
                                                i < res.length + 1;
                                                i++) {
                                              list.add(i);
                                            }
                                            setState(() {
                                              selectedIndexes = list;
                                            });
                                          } else {
                                            setState(() {
                                              selectedIndexes = [];
                                            });
                                          }
                                        },
                                        title: Text("SELECT ALL",
                                            style: TextStyle(
                                                fontSize: 20.r,
                                                fontFamily: "Prompt",
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    StyleUtil.primaryColor))),
                                    Divider(
                                      color: StyleUtil.primaryColor,
                                    )
                                  ],
                                );
                              } else {
                                if (res[index - 1] is Category) {
                                  return Column(
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            if (selectedIndexes
                                                .contains(index)) {
                                              setState(() {
                                                selectedIndexes.remove(index);
                                              });
                                            } else {
                                              setState(() {
                                                selectedIndexes.add(index);
                                              });
                                            }
                                          },
                                          trailing: Icon(
                                            !selectedIndexes.contains(index)
                                                ? Icons.highlight_off_rounded
                                                : Icons.check_circle,
                                            color: StyleUtil.primaryColor,
                                            size: 30.r,
                                          ),
                                          title: Text(
                                              "  Category " +
                                                  (res[index - 1] as Category)
                                                      .name,
                                              style: TextStyle(
                                                  fontSize: 20.r,
                                                  fontFamily: "Prompt",
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      StyleUtil.primaryColor))),
                                      Divider(
                                        color: StyleUtil.primaryColor,
                                      )
                                    ],
                                  );
                                }
                                if (res[index - 1] is MoneyBox) {
                                  return Column(
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            if (selectedIndexes
                                                .contains(index)) {
                                              setState(() {
                                                selectedIndexes.remove(index);
                                              });
                                            } else {
                                              setState(() {
                                                selectedIndexes.add(index);
                                              });
                                            }
                                          },
                                          trailing: Icon(
                                            !selectedIndexes.contains(index)
                                                ? Icons.highlight_off_rounded
                                                : Icons.check_circle,
                                            color: StyleUtil.primaryColor,
                                            size: 30.r,
                                          ),
                                          title: Text(
                                              "  MoneyBox " +
                                                  (res[index - 1] as MoneyBox)
                                                      .name,
                                              style: TextStyle(
                                                  fontSize: 20.r,
                                                  fontFamily: "Prompt",
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      StyleUtil.primaryColor))),
                                      Divider(
                                        color: StyleUtil.primaryColor,
                                      )
                                    ],
                                  );
                                }
                                if (res[index - 1] is Partner) {
                                  return Column(
                                    children: [
                                      ListTile(
                                          onTap: () {
                                            if (selectedIndexes
                                                .contains(index)) {
                                              setState(() {
                                                selectedIndexes.remove(index);
                                              });
                                            } else {
                                              setState(() {
                                                selectedIndexes.add(index);
                                              });
                                            }
                                          },
                                          trailing: Icon(
                                            !selectedIndexes.contains(index)
                                                ? Icons.highlight_off_rounded
                                                : Icons.check_circle,
                                            color: StyleUtil.primaryColor,
                                            size: 30.r,
                                          ),
                                          title: Text(
                                              "  Partner " +
                                                  (res[index - 1] as Partner)
                                                      .name,
                                              style: TextStyle(
                                                  fontSize: 20.r,
                                                  fontFamily: "Prompt",
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      StyleUtil.primaryColor))),
                                      Divider(
                                        color: StyleUtil.primaryColor,
                                      )
                                    ],
                                  );
                                }
                              }
                              return ListTile(title: Text(index.toString()));
                            }),
                      ),
                    ))
                  ],
                ),
              );
            } else
              return LoadingPage(StyleUtil.secondaryColor);
          },
        ),
      )),
    );
  }

  void generateQr(res) {
    String groupId = Uuid().v4();
    AddName(context, "Group Name", (controller) async {
      String groupName = controller.text;
      User user = await GetIt.I<SqliteService>().getUser();
      GetIt.I<SqliteService>()
          .addGroup(Group(id: groupId, name: controller.text, amount: 0.0));
      List<Map> partners = [];
      List<Map> moneyBoxes = [];
      List<Map> categories = [];
      List<Map> users = [];
      users.add(user.toMap());
      for (var index in selectedIndexes) {
        if (res[index - 1] is Partner) {
          GetIt.I<SqliteService>().addGroupPartners(res[index - 1], groupId);
          partners.add(res[index - 1].toMap());
        }
        if (res[index - 1] is Category) {
          GetIt.I<SqliteService>().addGroupCategories(res[index - 1], groupId);
          categories.add(res[index - 1].toMap());
        }

        if (res[index - 1] is MoneyBox) {
          GetIt.I<SqliteService>().addGroupMoneyBoxes(res[index - 1], groupId);
          moneyBoxes.add(res[index - 1].toMap());
        }
      }
      Map<String, Object> info = {
        "group_id": groupId,
        "group_name": groupName,
        "users": users,
        "partners": partners,
        "moneyBoxes": moneyBoxes,
        "categories": categories
      };
      const SECRET_KEY = "2020_PRIVATES_KEYS_ENCRYPTS_2020";
      final key = encrypt.Key.fromUtf8(SECRET_KEY);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(jsonEncode(info), iv: iv);
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      color: StyleUtil.primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: QrImage(
                    data: encrypted.base64,
                    version: QrVersions.auto,
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      );
    });
  }
}
