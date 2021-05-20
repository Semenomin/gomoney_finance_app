import 'package:bot_toast/bot_toast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddAmount.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/dialogs/RenameOrDelete.dart';
import 'package:gomoney_finance_app/model/Planned.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlannedCard extends StatelessWidget {
  final Planned planned;
  final Function update;
  PlannedCard(this.planned, this.update);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: Container(
        decoration: StyleUtil.rowndedBoxWithShadow
            .copyWith(color: StyleUtil.secondaryColor),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      AddAmount(context, "CHANGE AMOUNT", (controllerAmount) {
                        if (controllerAmount.text.contains(",")) {
                          controllerAmount.text.replaceAll(",", ".");
                        }
                        var amount = double.tryParse(controllerAmount.text);
                        if (amount != null) {
                          planned.amountOfMoney = amount;
                          GetIt.I<SqliteService>()
                              .changePlannedAmountOfMoney(planned);
                          update(0);
                          Navigator.pop(context);
                        } else {
                          BotToast.showText(text: "Wrong Amount");
                        }
                      });
                    },
                    child: Text(planned.amountOfMoney.toString(),
                        style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 20.r,
                            color: StyleUtil.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  VerticalDivider(),
                  GestureDetector(
                    onTap: () {
                      AreYouSure(context, "CHANGE OPERATION?", () {
                        planned.isIncome = !planned.isIncome;
                        GetIt.I<SqliteService>().changePlannedIsIncome(planned);
                        update(0);
                        Navigator.pop(context);
                      });
                    },
                    child: Icon(
                      planned.isIncome
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: StyleUtil.primaryColor,
                      size: 30.r,
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        RenameOrDelete(context, (controller) {
                          planned.name = controller.text;
                          GetIt.I<SqliteService>().changePlannedName(planned);
                          update(0);
                          Navigator.pop(context);
                        }, () {
                          GetIt.I<SqliteService>().deletePlanned(planned);
                          update(0);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(planned.name,
                          style: TextStyle(
                              fontFamily: "Prompt",
                              fontSize: 15.r,
                              color: StyleUtil.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.r).copyWith(top: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 170.r,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Center(
                                    child: Text(
                                        planned.dateTo
                                                .difference(DateTime.now())
                                                .inDays
                                                .toString() +
                                            " Days",
                                        style: TextStyle(
                                            fontFamily: "Prompt",
                                            fontSize: 25.r,
                                            color: StyleUtil.primaryColor,
                                            fontWeight: FontWeight.bold))),
                                PieChart(
                                  PieChartData(
                                      centerSpaceRadius: 55.r,
                                      sections: showingSections(
                                          dateFrom: planned.dateFrom,
                                          dateTo: planned.dateTo)),
                                  swapAnimationDuration:
                                      Duration(milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Text(
                                planned.dateTo.toString().substring(0, 10),
                                style: TextStyle(
                                    fontFamily: "Prompt",
                                    color: StyleUtil.primaryColor,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      {required DateTime dateTo, required DateTime dateFrom}) {
    List<PieChartSectionData> res = [];
    int dateToMili = dateTo.millisecondsSinceEpoch;
    int dateFromMili = dateFrom.millisecondsSinceEpoch;
    int fullCircle = dateToMili - dateFromMili;
    int dateNowMili = DateTime.now().millisecondsSinceEpoch;
    int pasedCircle = dateNowMili - dateFromMili;
    res.add(PieChartSectionData(
      color: StyleUtil.primaryColor,
      value: pasedCircle.toDouble(),
      radius: 20,
      showTitle: false,
    ));
    res.add(PieChartSectionData(
      color: StyleUtil.secondaryColor,
      value: fullCircle.toDouble() - pasedCircle.toDouble(),
      radius: 50,
      showTitle: false,
    ));
    return res;
  }
}
