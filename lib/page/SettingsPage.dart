import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/screen/BackupScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:currency_picker/currency_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          Divider(),
          ListTile(
            title: Row(
              children: [
                Text("Currency",
                    style: TextStyle(
                        fontSize: 30.r,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.bold,
                        color: StyleUtil.secondaryColor)),
                Expanded(child: Container()),
                Text(GetIt.I<PreferencesService>().getCurrency(),
                    style: TextStyle(
                        fontSize: 30.r,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.bold,
                        color: StyleUtil.secondaryColor)),
              ],
            ),
            onTap: () {
              showCurrencyPicker(
                  context: context,
                  showFlag: true,
                  showCurrencyName: true,
                  showCurrencyCode: true,
                  onSelect: (Currency currency) {
                    GetIt.I<PreferencesService>().setCurrency(currency);
                    update();
                  },
                  theme: CurrencyPickerThemeData(
                      backgroundColor: StyleUtil.primaryColor));
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  void update() {
    setState(() {});
  }
}
