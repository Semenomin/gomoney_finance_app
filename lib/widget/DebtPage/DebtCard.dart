import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddAmount.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/Partner.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

class DebtCard extends StatelessWidget {
  final bool isPlus;
  final bool isInitial;
  final Partner? partner;
  final String currensy;
  final Function? update;
  final int? selectedPage;
  const DebtCard(
      {this.partner,
      required this.currensy,
      this.isInitial = false,
      this.isPlus = false,
      this.update,
      this.selectedPage});

  @override
  Widget build(BuildContext context) {
    if (!isPlus) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: StyleUtil.rowndedBoxWithShadow
              .copyWith(color: StyleUtil.secondaryColor),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
                child: Row(
                  children: [
                    Container(
                        child: Text(partner!.name,
                            style: TextStyle(
                                fontSize: 20.r,
                                fontFamily: "Prompt",
                                fontWeight: FontWeight.bold,
                                color: StyleUtil.primaryColor))),
                    Expanded(child: Container()),
                    Visibility(
                        visible: !isInitial,
                        child: InkWell(
                          onTap: () => AreYouSure(context, "ARE YOU SURE?",
                              () => onDeletePartner(partner, context)),
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.primaryColor),
                            width: 30.r,
                            height: 30.r,
                            child: Icon(Icons.close),
                          ),
                        )),
                  ],
                ),
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
                                        name: "Debt Lend " + partner!.name,
                                        isIncome: false,
                                        date: DateTime.now(),
                                        currency: "",
                                        amountOfMoney:
                                            double.parse(controller.text),
                                        partnerId: partner!.id),
                                    partner: partner);
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
                                      size: 35.r),
                                )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          partner!.lendAmount
                                                  .toStringAsFixed(2) +
                                              " " +
                                              partner!.currency,
                                          style: TextStyle(
                                              fontSize: 20.r,
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
                                        name: "Debt Borrow " + partner!.name,
                                        isIncome: true,
                                        date: DateTime.now(),
                                        currency: "",
                                        amountOfMoney:
                                            double.parse(controller.text),
                                        partnerId: partner!.id),
                                    partner: partner);
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
                                      size: 35.r),
                                )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                          partner!.borrowAmount
                                                  .toStringAsFixed(2) +
                                              " " +
                                              partner!.currency,
                                          style: TextStyle(
                                              fontSize: 20.r,
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
        onTap: () => AddName(context, "ADD PARTNER", (controller) {
          GetIt.I<SqliteService>().addPartner(Partner(
              id: Uuid().v4(),
              name: controller.text,
              lendAmount: 0.0,
              borrowAmount: 0.0,
              currency: "",
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
                    Icon(Icons.add, color: StyleUtil.primaryColor, size: 60.r),
              ),
            ),
          ),
        ),
      );
  }

  void onDeletePartner(partner, context) {
    GetIt.I<SqliteService>().deletePartner(partner);
    update!(selectedPage! - 1);
    Navigator.pop(context);
  }
}
