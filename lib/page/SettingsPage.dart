import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/screen/BackupScreen.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(),
          ListTile(
            title: Row(
              children: [
                Text("Backup",
                    style: TextStyle(
                        fontSize: 30.r,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.bold,
                        color: StyleUtil.secondaryColor)),
                Expanded(child: Container()),
                Icon(
                  Icons.arrow_right,
                  size: 35.h,
                  color: StyleUtil.secondaryColor,
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BackupScreen()),
              );
            },
          ),
          Divider()
        ],
      ),
    );
  }
}
