import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AreYouSure {
  AreYouSure(context, onTap) {
    showMaterialModalBottomSheet(
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
                        child: Text("ARE YOU SURE?",
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 30.w,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: StyleUtil.rowndedBoxWithShadow
                                      .copyWith(color: StyleUtil.primaryColor),
                                  child: Center(
                                    child: Text("CANCEL",
                                        style: TextStyle(
                                            fontSize: 30.w,
                                            fontFamily: "Prompt",
                                            fontWeight: FontWeight.bold,
                                            color: StyleUtil.secondaryColor)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: onTap,
                                child: Container(
                                  decoration: StyleUtil.rowndedBoxWithShadow
                                      .copyWith(color: StyleUtil.primaryColor),
                                  child: Center(
                                    child: Text("GO",
                                        style: TextStyle(
                                            fontSize: 30.w,
                                            fontFamily: "Prompt",
                                            fontWeight: FontWeight.bold,
                                            color: StyleUtil.secondaryColor)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
