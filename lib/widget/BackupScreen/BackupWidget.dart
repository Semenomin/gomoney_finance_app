import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
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
              GetIt.I<PreferencesService>().getDateOfLastBackup().toString() ==
                      "null"
                  ? Icons.highlight_off_rounded
                  : Icons.check_circle,
              color: StyleUtil.secondaryColor,
              size: 30.r,
            )
          ],
        ),
        subtitle: Text(
            "Last update : " +
                (GetIt.I<PreferencesService>()
                            .getDateOfLastBackup()
                            .toString() ==
                        "null"
                    ? "Empty"
                    : GetIt.I<PreferencesService>()
                        .getDateOfLastBackup()
                        .toString()),
            style: TextStyle(color: StyleUtil.secondaryColor)),
        onTap: () => onTap());
  }
}
