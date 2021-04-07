import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/widget/ChartsPage/ChartGridElement.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              ChartGridElement(ChartType.CIRCLE, true),
              ChartGridElement(ChartType.LINEAR, true),
              ChartGridElement(ChartType.BAR, true),
            ],
          ),
        ),
      ],
    );
  }
}
