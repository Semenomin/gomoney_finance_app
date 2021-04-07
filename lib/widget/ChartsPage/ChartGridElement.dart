import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class ChartGridElement extends StatelessWidget {
  final ChartType type;
  final bool isMinimized;
  ChartGridElement(this.type, this.isMinimized);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: StyleUtil.rowndedBoxWithShadow
            .copyWith(color: StyleUtil.secondaryColor),
        child: _buildChart(type));
  }

  Widget _buildChart(ChartType type) {
    switch (type) {
      case ChartType.CIRCLE:
        return PieChart(
          PieChartData(sections: [
            PieChartSectionData(
                title: '', color: StyleUtil.primaryColor.withOpacity(1)),
            PieChartSectionData(
                title: '', color: StyleUtil.primaryColor.withOpacity(0.8)),
            PieChartSectionData(
                title: '', color: StyleUtil.primaryColor.withOpacity(0.6)),
          ]),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        );
      case ChartType.LINEAR:
        return LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              ),
              touchCallback: (LineTouchResponse touchResponse) {},
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                reservedSize: 22,
                getTextStyles: (value) => const TextStyle(
                  color: Color(0xff72719b),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              leftTitles: SideTitles(
                getTextStyles: (value) => const TextStyle(
                  color: Color(0xff75729e),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                reservedSize: 30,
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
            lineBarsData: linesBarData1(),
          ),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        );
      case ChartType.BAR:
        return BarChart(
          randomData(),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        );
      default:
        return Container();
    }
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(1));
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.9));
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.8));
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.7));
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.6));
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.5));
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.primaryColor.withOpacity(0.4));
          default:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: StyleUtil.secondaryColor.withOpacity(0.3));
        }
      }),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [Colors.transparent],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        StyleUtil.primaryColor.withOpacity(1),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        StyleUtil.primaryColor.withOpacity(0.6),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: [
        StyleUtil.primaryColor.withOpacity(0.2),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }
}
