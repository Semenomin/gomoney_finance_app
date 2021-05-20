import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddName {
  AddName(context, title, void onTap(TextEditingController controller)) {
    TextEditingController _nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Container(
                  decoration: BoxDecoration(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      AppUtils.emptyContainer(double.infinity, 20.r),
                      Container(
                        padding: EdgeInsets.all(15.r),
                        child: Text(title,
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 30.r,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Name", _nameController,
                          TextInputType.text, StyleUtil.primaryColor),
                      Padding(
                        padding: EdgeInsets.all(5.r),
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          child: InkWell(
                            onTap: () => onTap(_nameController),
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
