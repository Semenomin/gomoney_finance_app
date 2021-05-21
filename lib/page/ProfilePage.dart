import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/model/Partner.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/screen/ShareToUserScreen.dart';
import 'package:gomoney_finance_app/service/ConnectionService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<SqliteService>().getUser(),
        builder: (context, AsyncSnapshot<User> user) {
          return FutureBuilder(
              future: GetIt.I<SqliteService>().getGroups(),
              builder: (context, AsyncSnapshot<List<Group>> groups) {
                if (groups.hasData) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: groups.data!.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Divider(),
                            ListTile(
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.person,
                                      color: StyleUtil.secondaryColor,
                                    ),
                                  ),
                                  Text(
                                    user.data!.name,
                                    style: TextStyle(
                                      color: StyleUtil.secondaryColor,
                                      fontSize: 17.w,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Prompt",
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      user.data!.amountOfMoney
                                          .toStringAsFixed(2),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: StyleUtil.secondaryColor,
                                        fontSize: 15.r,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Prompt",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                          ],
                        );
                      } else if (index != 0 &&
                          index != groups.data!.length + 1) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                generateQr(groups.data![index - 1], context);
                              },
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.group,
                                      color: StyleUtil.secondaryColor,
                                    ),
                                  ),
                                  Text(
                                    groups.data![index - 1].name,
                                    style: TextStyle(
                                      color: StyleUtil.secondaryColor,
                                      fontSize: 17.w,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Prompt",
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            ListTile(
                              title: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 40.r,
                                  color: StyleUtil.secondaryColor,
                                ),
                              ),
                              onTap: () => addGroup(context),
                            ),
                            Divider()
                          ],
                        );
                      }
                    },
                  );
                } else
                  return LoadingPage(StyleUtil.secondaryColor);
              });
        });
  }

  void generateQr(Group group, context) async {
    String groupId = group.id;
    String groupName = group.name;
    var users = await GetIt.I<SqliteService>().getGroupUsers(group);
    var moneyBoxesIds =
        await GetIt.I<SqliteService>().getGroupMoneyBoxes(group.id);
    var partnersIds = await GetIt.I<SqliteService>().getGroupPartners(group.id);
    var categoriesIds =
        await GetIt.I<SqliteService>().getGroupCategories(group.id);
    var moneyBoxes =
        await GetIt.I<SqliteService>().getMoneyBoxesByIds(moneyBoxesIds);
    var partners = await GetIt.I<SqliteService>().getPartnersByIds(partnersIds);
    var categories =
        await GetIt.I<SqliteService>().getCategoriesByIds(categoriesIds);
    List<Map> usersMap = [];
    List<Map> partnersMap = [];
    List<Map> moneyBoxesMap = [];
    List<Map> categoriesMap = [];
    for (User user in users) {
      usersMap.add(user.toMap());
    }
    for (var moneyBox in moneyBoxes) {
      moneyBoxesMap.add(moneyBox.toMap());
    }
    for (var category in categories) {
      categoriesMap.add(category.toMap());
    }
    for (var partner in partners) {
      partnersMap.add(partner.toMap());
    }
    Map<String, Object> info = {
      "group_id": groupId,
      "group_name": groupName,
      "users": usersMap,
      "partners": partnersMap,
      "moneyBoxes": moneyBoxesMap,
      "categories": categoriesMap
    };
    const SECRET_KEY = "2020_PRIVATES_KEYS_ENCRYPTS_2020";
    final key = encrypt.Key.fromUtf8(SECRET_KEY);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(jsonEncode(info), iv: iv);
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
  }

  Future<void> addGroup(context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
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
                            onTap: () async {
                              Permission.camera.request();
                              List<User> users = [];
                              List<String> pushes = [];
                              const SECRET_KEY =
                                  "2020_PRIVATES_KEYS_ENCRYPTS_2020";
                              String cameraScanResult = await scanner.scan();
                              print(cameraScanResult);
                              final key = encrypt.Key.fromUtf8(SECRET_KEY);
                              final iv = encrypt.IV.fromLength(16);
                              final encrypter =
                                  encrypt.Encrypter(encrypt.AES(key));
                              var json = jsonDecode(encrypter
                                  .decrypt64(cameraScanResult, iv: iv));
                              print(json);
                              GetIt.I<SqliteService>().addGroup(Group(
                                  id: json["group_id"],
                                  name: json["group_name"],
                                  amount: 0.0));
                              for (var user in json["users"]) {
                                users.add(User.fromMap(user));
                                pushes.add(User.fromMap(user).pushId);
                                GetIt.I<SqliteService>()
                                    .addUser(User.fromMap(user));
                              }
                              for (var partner in json["partners"]) {
                                GetIt.I<SqliteService>()
                                    .addPartner(Partner.fromMap(partner));
                                GetIt.I<SqliteService>().addGroupPartners(
                                    Partner.fromMap(partner), json["group_id"]);
                              }
                              for (var moneyBox in json["moneyBoxes"]) {
                                GetIt.I<SqliteService>()
                                    .addMoneyBox(MoneyBox.fromMap(moneyBox));
                                GetIt.I<SqliteService>().addGroupMoneyBoxes(
                                    MoneyBox.fromMap(moneyBox),
                                    json["group_id"]);
                              }
                              for (var category in json["categories"]) {
                                GetIt.I<SqliteService>()
                                    .addCategory(Category.fromMap(category));
                                GetIt.I<SqliteService>().addGroupCategories(
                                    Category.fromMap(category),
                                    json["group_id"]);
                              }
                              GetIt.I<SqliteService>().addGroupUsers(
                                  Group(
                                      id: json["group_id"],
                                      name: json["group_name"],
                                      amount: 0.0),
                                  users);
                              GetIt.I<ConnectionService>().confirmInvite(
                                  Group(
                                      id: json["group_id"],
                                      name: json["group_name"],
                                      amount: 0.0),
                                  pushes,
                                  await GetIt.I<SqliteService>().getUser());
                            },
                            title: Text("Join To Group",
                                style: TextStyle(
                                  fontSize: 20.r,
                                  color: StyleUtil.primaryColor,
                                ))),
                        Divider(height: 0),
                        ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareToUserScreen()),
                              );
                            },
                            title: Text("Create Group",
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
}
