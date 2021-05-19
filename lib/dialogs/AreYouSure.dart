import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/model/index.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class AreYouSure {
  AreYouSure(context, title, onTap, {String? scanId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
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
                                fontSize: 30.r,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10.r),
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
                                            fontSize: 25.r,
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
                              padding: EdgeInsets.all(10.r),
                              child: InkWell(
                                onTap: scanId == null
                                    ? onTap
                                    : () => _onScan(context, scanId),
                                child: Container(
                                  decoration: StyleUtil.rowndedBoxWithShadow
                                      .copyWith(color: StyleUtil.primaryColor),
                                  child: Center(
                                    child: Text("GO",
                                        style: TextStyle(
                                            fontSize: 25.r,
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

  void _onScan(context, String scanId) async {
    Navigator.pop(context);
    TextEditingController _nameController = TextEditingController();
    TextEditingController _amountController = TextEditingController();
    Scan scan = await GetIt.I<SqliteService>().getScanById(scanId);
    _nameController.text = scan.name;
    _amountController.text = scan.transactionNum.toString();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Container(
                  decoration: BoxDecoration(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      AppUtils.emptyContainer(double.infinity, 20.h),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text("ADD SCAN TRANSACTION",
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 20.w,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Name", _nameController,
                          TextInputType.text, StyleUtil.primaryColor),
                      AppUtils.emptyContainer(double.infinity, 20.r),
                      AppUtils.textForm("Amount", _amountController,
                          TextInputType.number, StyleUtil.primaryColor),
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              GetIt.I<SqliteService>().addTransaction(
                                  FinTransaction(
                                      id: Uuid().v4(),
                                      name: "Scan " + _nameController.text,
                                      isIncome: false,
                                      date: DateTime.now(),
                                      amountOfMoney: double.parse(
                                          _amountController.text)));
                              Navigator.pop(context);
                            },
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
