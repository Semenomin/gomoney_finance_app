import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNameAndAmount {
  AddNameAndAmount(
      context,
      title,
      update,
      void onTap(TextEditingController controllerName,
          TextEditingController controllerAmount)) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
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
                      AppUtils.textForm("Name", _nameController,
                          TextInputType.text, StyleUtil.primaryColor),
                      AppUtils.textForm("Amount", _amountController,
                          TextInputType.number, StyleUtil.primaryColor),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            onTap(_nameController, _amountController);
                            update();
                          },
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
