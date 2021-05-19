import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/BackupService.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading {
  Loading(context, title) {
    var token = GetIt.I<PreferencesService>().getToken();
    showMaterialModalBottomSheet(
      expand: true,
      enableDrag: false,
      context: context,
      builder: (context) => FutureBuilder(
        future: token == null
            ? GetIt.I<BackupService>().signInBackup(context)
            : GetIt.I<BackupService>().connectBackup(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
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
                                      fontSize: 30.w,
                                      color: StyleUtil.primaryColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: LoadingPage(StyleUtil.primaryColor),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            );
          } else
            return LoadingPage(StyleUtil.primaryColor);
        },
      ),
    );
  }
}
