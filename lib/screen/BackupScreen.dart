import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/dialogs/Loading.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/backupScreen/BackupWidget.dart';

class BackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: StyleUtil.primaryColor,
          child: Column(
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
              Column(
                children: [
                  Divider(),
                  BackupWidget(
                      title: "Google Drive", onTap: () => onTapGoogle(context)),
                  Divider(),
                ],
              ),
              Expanded(child: Container()),
              Divider(),
              Visibility(child: ListTile())
            ],
          ),
        ),
      )),
    );
  }

  void onTapGoogle(context) async {
    Loading(context, "BACKUP");
  }
}
