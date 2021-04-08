import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/dialogs/RegisterAndLogin.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackupWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  const BackupWidget({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 30.r,
                    fontFamily: "Prompt",
                    fontWeight: FontWeight.bold,
                    color: StyleUtil.secondaryColor)),
            Expanded(child: Container()),
            Icon(
              Icons.highlight_off_rounded,
              color: StyleUtil.secondaryColor,
              size: 30.r,
            )
          ],
        ),
        //TODO show if exists
        subtitle: Text("Last update : " + DateTime.now().toString(),
            style: TextStyle(color: StyleUtil.secondaryColor)),
        onTap: () {
          RegisterAndLogin(context, title, onTap);
        });
  }
}
