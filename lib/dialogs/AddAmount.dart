import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAmount {
  AddAmount(context, title, void onTap(TextEditingController controller)) {
    TextEditingController _amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Container(
                  decoration: BoxDecoration(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.r),
                        child: Text(title,
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 35.r,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Amount", _amountController,
                          TextInputType.number, StyleUtil.primaryColor),
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Container(
                          child: InkWell(
                            onTap: () => onTap(_amountController),
                            child: Container(
                              decoration: StyleUtil.rowndedBoxWithShadow
                                  .copyWith(color: StyleUtil.primaryColor),
                              child: Center(
                                child: Text("GO",
                                    style: TextStyle(
                                        fontSize: 40.r,
                                        fontFamily: "Prompt",
                                        fontWeight: FontWeight.bold,
                                        color: StyleUtil.secondaryColor)),
                              ),
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
