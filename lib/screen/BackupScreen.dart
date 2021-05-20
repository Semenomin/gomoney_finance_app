import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/Loading.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/BackupScreen/BackupWidget.dart';

class BackupScreen extends StatefulWidget {
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
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
              ListTile(
                title: Row(
                  children: [
                    Text("Daily"),
                    Expanded(child: Container()),
                    Icon(
                      GetIt.I<PreferencesService>().getBackupLoop() != 0
                          ? Icons.highlight_off_rounded
                          : Icons.check_circle,
                      color: StyleUtil.secondaryColor,
                      size: 30.r,
                    )
                  ],
                ),
                onTap: () {
                  GetIt.I<PreferencesService>().setBackupLoop(0);
                  setState(() {});
                },
              ),
              Divider(),
              ListTile(
                title: Row(
                  children: [
                    Text("Weekly"),
                    Expanded(child: Container()),
                    Icon(
                      GetIt.I<PreferencesService>().getBackupLoop() != 1
                          ? Icons.highlight_off_rounded
                          : Icons.check_circle,
                      color: StyleUtil.secondaryColor,
                      size: 30.r,
                    )
                  ],
                ),
                onTap: () {
                  GetIt.I<PreferencesService>().setBackupLoop(1);
                  setState(() {});
                },
              ),
              Divider(),
              ListTile(
                title: Row(
                  children: [
                    Text("Monthly"),
                    Expanded(child: Container()),
                    Icon(
                      GetIt.I<PreferencesService>().getBackupLoop() != 2
                          ? Icons.highlight_off_rounded
                          : Icons.check_circle,
                      color: StyleUtil.secondaryColor,
                      size: 30.r,
                    )
                  ],
                ),
                onTap: () {
                  GetIt.I<PreferencesService>().setBackupLoop(2);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      )),
    );
  }

  void onTapGoogle(context) async {
    Loading(context, "BACKUP");
    setState(() {});
  }
}
