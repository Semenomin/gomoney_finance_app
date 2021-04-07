import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/dialogs/AddAmount.dart';
import 'package:gomoney_finance_app/dialogs/AddUser.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class DebtCard extends StatelessWidget {
  final bool isPlus;
  final bool isInitial;
  final double income;
  final double expense;
  final String name;
  final String currensy;
  const DebtCard(
      {required this.name,
      required this.income,
      required this.expense,
      required this.currensy,
      this.isInitial = false,
      this.isPlus = false});

  @override
  Widget build(BuildContext context) {
    if (!isPlus) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: StyleUtil.rowndedBoxWithShadow
              .copyWith(color: StyleUtil.secondaryColor),
          height: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(15.w),
                      child: Text(name,
                          style: TextStyle(
                              fontSize: 20.w,
                              fontFamily: "Prompt",
                              fontWeight: FontWeight.bold,
                              color: StyleUtil.primaryColor))),
                  Expanded(child: Container()),
                  Visibility(
                    visible: !isInitial,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        onPressed: () => AreYouSure(context, onTap),
                        elevation: 4.0,
                        fillColor: StyleUtil.primaryColor,
                        child: Icon(
                          Icons.close,
                          size: 35.w,
                          color: StyleUtil.secondaryColor,
                        ),
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () => !isInitial
                            ? AddAmount(context, "LEND", onTap)
                            : () {},
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            child: Row(children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    child: Center(
                                  child: Icon(Icons.arrow_upward,
                                      color: StyleUtil.primaryColor,
                                      size: 35.w),
                                )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          expense.toString() + " " + currensy,
                                          style: TextStyle(
                                              fontSize: 20.w,
                                              fontFamily: "Prompt",
                                              fontWeight: FontWeight.bold,
                                              color: StyleUtil.primaryColor))),
                                ),
                              )
                            ]),
                          ),
                        ),
                      )),
                      VerticalDivider(color: StyleUtil.primaryColor),
                      Expanded(
                          child: InkWell(
                        onTap: () => !isInitial
                            ? AddAmount(context, "BORROW", onTap)
                            : () {},
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            child: Row(children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                    child: Center(
                                  child: Icon(Icons.arrow_downward,
                                      color: StyleUtil.primaryColor,
                                      size: 35.w),
                                )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          income.toString() + " " + currensy,
                                          style: TextStyle(
                                              fontSize: 20.w,
                                              fontFamily: "Prompt",
                                              fontWeight: FontWeight.bold,
                                              color: StyleUtil.primaryColor))),
                                ),
                              )
                            ]),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () => AddUser(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: StyleUtil.rowndedBoxWithShadow
                .copyWith(color: StyleUtil.secondaryColor),
            height: double.infinity,
            child: Center(
              child: Center(
                child:
                    Icon(Icons.add, color: StyleUtil.primaryColor, size: 60.w),
              ),
            ),
          ),
        ),
      );
    }
  }
}

//TODO
void onTap() {}
