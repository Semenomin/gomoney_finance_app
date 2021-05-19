import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlannedCard extends StatelessWidget {
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
                  Text("200\$",
                      style: TextStyle(
                          fontFamily: "Prompt",
                          fontSize: 20.r,
                          color: StyleUtil.primaryColor,
                          fontWeight: FontWeight.bold)),
                  Icon(
                    Icons.arrow_downward,
                    color: StyleUtil.primaryColor,
                    size: 30.r,
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Text("Зарплата БелТрансСпутник",
                        style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 15.r,
                            color: StyleUtil.primaryColor,
                            fontWeight: FontWeight.bold)),
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
                                    child: Text("2 дня",
                                        style: TextStyle(
                                            fontFamily: "Prompt",
                                            fontSize: 25.r,
                                            color: StyleUtil.primaryColor,
                                            fontWeight: FontWeight.bold))),
                                PieChart(
                                  PieChartData(
                                      centerSpaceRadius: 55.r,
                                      sections: showingSections(
                                          dateFrom:
                                              DateTime(2021, 1, 10, 12, 0, 0),
                                          dateTo:
                                              DateTime(2021, 6, 10, 12, 0, 0))),
                                  swapAnimationDuration:
                                      Duration(milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear, // Optional
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Text(
                                DateTime.now().toString().substring(0, 10),
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
