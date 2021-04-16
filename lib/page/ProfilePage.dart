import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                                    groups.data![index].name,
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
                                      groups.data![index].amount
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
                              onTap: addGroup,
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
}

Future<void> addGroup() async {}
