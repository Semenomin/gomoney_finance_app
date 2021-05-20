import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Planned.dart';
import 'package:gomoney_finance_app/model/index.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class AddPlannedScreen extends StatefulWidget {
  final bool isIncome;

  AddPlannedScreen(this.isIncome);

  @override
  _AddPlannedScreenState createState() => _AddPlannedScreenState();
}

class _AddPlannedScreenState extends State<AddPlannedScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime? dateTo;
  DateTime dateFrom =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: StyleUtil.primaryColor,
          child: Column(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 60.r,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: double.infinity,
                        width: 60.r,
                        child: FittedBox(
                          child: Icon(
                            Icons.arrow_back,
                            color: StyleUtil.secondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AppUtils.textForm("Name", _nameController, TextInputType.text,
                  StyleUtil.secondaryColor),
              AppUtils.textForm("Amount", _amountController,
                  TextInputType.number, StyleUtil.secondaryColor),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20.r).copyWith(top: 0, right: 0),
                      child: Container(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: dateFrom,
                                firstDate: DateTime(2015, 8),
                                lastDate:
                                    dateTo == null ? DateTime(2101) : dateTo!);
                            if (picked != null) {
                              setState(() {
                                dateFrom = picked;
                              });
                            }
                          },
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.secondaryColor),
                            child: Center(
                              child: Text(dateFrom.toString().substring(0, 10),
                                  style: TextStyle(
                                      fontSize: 25.r,
                                      fontFamily: "Prompt",
                                      fontWeight: FontWeight.bold,
                                      color: StyleUtil.primaryColor)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20.r).copyWith(top: 0, left: 0),
                      child: Container(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: dateFrom,
                                firstDate: dateFrom,
                                lastDate: DateTime(2101));
                            if (picked != null) {
                              setState(() {
                                dateTo = picked;
                              });
                            }
                          },
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.secondaryColor),
                            child: Center(
                              child: Text(
                                  dateTo != null
                                      ? dateTo.toString().substring(0, 10)
                                      : "Select",
                                  style: TextStyle(
                                      fontSize: 25.r,
                                      fontFamily: "Prompt",
                                      fontWeight: FontWeight.bold,
                                      color: StyleUtil.primaryColor)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.all(20.r).copyWith(top: 0),
                child: Container(
                  child: InkWell(
                    onTap: () async {
                      if (dateTo != null) {
                        if (_amountController.text.contains(",")) {
                          _amountController.text.replaceAll(",", '.');
                        }
                        double? amount =
                            double.tryParse(_amountController.text);
                        if (amount != null) {
                          if (dateFrom.microsecondsSinceEpoch >
                              DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day)
                                  .microsecondsSinceEpoch) {
                            GetIt.I<SqliteService>().addPlanned(Planned(
                                id: Uuid().v4(),
                                name: _nameController.text,
                                amountOfMoney: amount,
                                dateFrom: dateFrom.subtract(Duration(
                                    days: dateTo!.difference(dateFrom).inDays)),
                                dateTo: dateFrom,
                                isIncome: widget.isIncome));
                            Navigator.pop(context);
                          } else {
                            GetIt.I<SqliteService>().addPlanned(Planned(
                                id: Uuid().v4(),
                                name: _nameController.text,
                                amountOfMoney: amount,
                                dateFrom: dateFrom,
                                dateTo: dateTo!,
                                isIncome: widget.isIncome));
                            GetIt.I<SqliteService>().addTransaction(
                                FinTransaction(
                                    id: Uuid().v4(),
                                    name: "Planned " + _nameController.text,
                                    isIncome: widget.isIncome,
                                    date: DateTime.now(),
                                    amountOfMoney: amount));
                            Navigator.pop(context);
                          }
                        } else {
                          BotToast.showText(text: "Incorrect amount");
                        }
                      } else {
                        BotToast.showText(text: "Set date, please!");
                      }
                    },
                    child: Container(
                      decoration: StyleUtil.rowndedBoxWithShadow
                          .copyWith(color: StyleUtil.secondaryColor),
                      child: Center(
                        child: Text("GO",
                            style: TextStyle(
                                fontSize: 40.r,
                                fontFamily: "Prompt",
                                fontWeight: FontWeight.bold,
                                color: StyleUtil.primaryColor)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
