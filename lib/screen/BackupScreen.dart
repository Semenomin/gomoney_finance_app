import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/backupScreen/BackupWidget.dart';

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
                BackupWidget(title: "OneDrive", onTap: onTap),
                Divider(),
                BackupWidget(title: "Google Drive", onTap: onTap),
                Divider(),
                BackupWidget(title: "Yandex Disk", onTap: onTap),
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

void onTap() {
  //TODO
}
