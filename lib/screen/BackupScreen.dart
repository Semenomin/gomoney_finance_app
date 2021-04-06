import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [StyleUtil.primaryColor, Colors.yellow.shade700])),
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 60.h,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: double.infinity,
                      width: 60.h,
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
            Column(
              children: [
                Divider(),
                BackupWidget(title: "OneDrive"),
                Divider(),
                BackupWidget(title: "Google Drive"),
                Divider(),
                BackupWidget(title: "Yandex Disk"),
                Divider(),
              ],
            ),
            Expanded(child: Container()),
            Divider(),
            Visibility(child: ListTile()),
            Divider(),
            Visibility(child: ListTile()),
            Divider(),
            Visibility(child: ListTile())
          ],
        ),
      ),
    ));
  }
}

class BackupWidget extends StatelessWidget {
  final String title;
  const BackupWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 30.w,
                    fontFamily: "Prompt",
                    fontWeight: FontWeight.bold,
                    color: StyleUtil.secondaryColor)),
            Expanded(child: Container()),
            Icon(
              Icons.highlight_off_rounded,
              color: StyleUtil.secondaryColor,
              size: 30.h,
            )
          ],
        ),
        //TODO show if exists
        subtitle: Text("Last update : " + DateTime.now().toString(),
            style: TextStyle(color: StyleUtil.secondaryColor)),
        onTap: () {
          showLoginSheet(context, title);
        });
  }

  Future showLoginSheet(BuildContext context, String title) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return showMaterialModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => SingleChildScrollView(
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
                                fontSize: 40.h,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Email", _emailController,
                          TextInputType.emailAddress, StyleUtil.primaryColor),
                      AppUtils.textForm(
                          "Password",
                          _passwordController,
                          TextInputType.visiblePassword,
                          StyleUtil.primaryColor),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: StyleUtil.rowndedBoxWithShadow
                              .copyWith(color: StyleUtil.primaryColor),
                          child: Center(
                            child: Text("GO",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.bold,
                                    color: StyleUtil.secondaryColor)),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
