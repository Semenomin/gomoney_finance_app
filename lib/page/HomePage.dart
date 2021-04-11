import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtHistoryListTile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? date;
  PageController? controller;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    controller = PageController(initialPage: date!.day);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<SqliteService>().getTransactionsByDate(date!),
      builder: (context, AsyncSnapshot<List<FinTransaction>> transactions) {
        if (transactions.hasData) {
          var spots = List.generate(
              transactions.data!.length,
              (index) => FlSpot(
                  transactions.data![index].date.hour.toDouble() * 3600 +
                      transactions.data![index].date.minute.toDouble() * 60 +
                      transactions.data![index].date.second.toDouble(),
                  transactions.data![index].isIncome
                      ? transactions.data![index].amountOfMoney
                      : -transactions.data![index].amountOfMoney));
          return Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 200.r,
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: transactions.data!.length != 0
                      ? LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                tooltipBgColor:
                                    Colors.blueGrey.withOpacity(0.8),
                              ),
                              touchCallback:
                                  (LineTouchResponse touchResponse) {},
                              handleBuiltInTouches: true,
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: SideTitles(
                                  showTitles: true,
                                  interval: 3600,
                                  getTextStyles: (value) => TextStyle(
                                        color: StyleUtil.secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                  getTitles: (value) {
                                    return (value ~/ 3600).toInt().toString() +
                                        "h";
                                  }),
                              leftTitles: SideTitles(
                                showTitles: false,
                                getTextStyles: (value) => TextStyle(
                                  color: StyleUtil.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                margin: 20,
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                bottom: BorderSide(
                                  color: Colors.transparent,
                                ),
                                left: BorderSide(
                                  color: Colors.transparent,
                                ),
                                right: BorderSide(
                                  color: Colors.transparent,
                                ),
                                top: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            lineBarsData: linesBarData1(spots),
                          ),
                          swapAnimationDuration:
                              Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear,
                        )
                      : Container()),
              Divider(),
              Expanded(
                  child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: controller,
                itemCount: DateUtils.getDaysInMonth(date!.year, date!.month),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(date.toString().substring(0, 10),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Prompt",
                                  color: StyleUtil.secondaryColor)),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: transactions.data!.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DebtHistoryListTile(
                                  type: transactions
                                          .data![transactions.data!.length -
                                              index -
                                              1]
                                          .isIncome
                                      ? TransactionType.INCOME
                                      : TransactionType.EXPENSE,
                                  name: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .name,
                                  date: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .date,
                                  amount: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .amountOfMoney,
                                  currency: "RUB");
                            }),
                      )
                    ],
                  );
                },
                onPageChanged: (page) {
                  setState(() {
                    date = DateTime(date!.year, date!.month, page);
                  });
                },
              )),
            ],
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }

  List<LineChartBarData> linesBarData1(spots) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      colors: [
        StyleUtil.secondaryColor.withOpacity(1),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [
      lineChartBarData1,
    ];
  }
}
