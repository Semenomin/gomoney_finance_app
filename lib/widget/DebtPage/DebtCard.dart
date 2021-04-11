import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddAmount.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/model/Debtor.dart';
import 'package:gomoney_finance_app/model/index.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class DebtCard extends StatelessWidget {
  final bool isPlus;
  final bool isInitial;
  final Debtor? debtor;
  final String currensy;
  final Function? update;
  final int? selectedPage;
  const DebtCard(
      {this.debtor,
      required this.currensy,
      this.isInitial = false,
      this.isPlus = false,
      this.update,
      this.selectedPage});

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
                      child: Text(debtor!.name,
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
                        onPressed: () => AreYouSure(
                            context, () => onDeleteDebtor(debtor, context)),
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
                            ? AddAmount(context, "LEND", (controller) {
                                GetIt.I<SqliteService>().addTransaction(
                                    FinTransaction(
                                        id: Uuid().v4(),
                                        name: "Debt Lend " + debtor!.name,
                                        isIncome: false,
                                        date: DateTime.now(),
                                        amountOfMoney:
                                            double.parse(controller.text),
                                        debtorId: debtor!.id),
                                    debtor: debtor);
                                update!(selectedPage);
                                Navigator.pop(context);
                              })
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
                                          debtor!.lendAmount
                                                  .toStringAsFixed(2) +
                                              " " +
                                              currensy,
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
                            ? AddAmount(context, "BORROW", (controller) {
                                GetIt.I<SqliteService>().addTransaction(
                                    FinTransaction(
                                        id: Uuid().v4(),
                                        name: "Debt Borrow " + debtor!.name,
                                        isIncome: true,
                                        date: DateTime.now(),
                                        amountOfMoney:
                                            double.parse(controller.text),
                                        debtorId: debtor!.id),
                                    debtor: debtor);
                                update!(selectedPage);
                                Navigator.pop(context);
                              })
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
                                          debtor!.borrowAmount
                                                  .toStringAsFixed(2) +
                                              " " +
                                              currensy,
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
    } else
      return InkWell(
        onTap: () => AddName(context, "ADD DEBTOR", (controller) {
          GetIt.I<SqliteService>().addDebtor(Debtor(
              id: Uuid().v4(),
              name: controller.text,
              lendAmount: 0.0,
              borrowAmount: 0.0,
              userId: GetIt.I<PreferencesService>().getToken()));
          update!(0);
          Navigator.pop(context);
        }),
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

  void onDeleteDebtor(debtor, context) {
    GetIt.I<SqliteService>().deleteDebtor(debtor);
    update!(selectedPage! - 1);
    Navigator.pop(context);
  }
}
