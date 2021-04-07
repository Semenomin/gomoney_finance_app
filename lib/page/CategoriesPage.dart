import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/CategoriesPage/CategoryGridItem.dart';
import 'package:gomoney_finance_app/widget/Indicator.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int? touchedIndex;
  List<Category> categories = [
    Category(name: "Productssssss", amount: 100, color: Colors.black),
    Category(name: "Flex", amount: 200, color: Colors.green),
    Category(name: "Car", amount: 300, color: Colors.red),
    Category(name: "Sex", amount: 400, color: Colors.blue),
    Category(name: "Penus", amount: 500, color: Colors.white),
    Category(name: "Pines", amount: 600, color: Colors.brown),
    Category(name: "Shacke", amount: 700, color: Colors.cyan),
    Category(name: "Smoke", amount: 800, color: Colors.deepPurple),
    Category(name: "Smoe", amount: 800, color: Colors.deepPurple),
    Category(name: "Smke", amount: 800, color: Colors.deepPurple),
    Category(name: "Soke", amount: 800, color: Colors.deepPurple),
    Category(name: "moke", amount: 800, color: Colors.deepPurple),
    Category(name: "Semoke", amount: 800, color: Colors.deepPurple),
    Category(name: "Smeoke", amount: 800, color: Colors.deepPurple),
    Category(name: "Smoeke", amount: 800, color: Colors.deepPurple),
    Category(name: "Smokee", amount: 800, color: Colors.deepPurple),
    Category(name: "Smokeee", amount: 800, color: Colors.deepPurple),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: StyleUtil.rowndedBoxWithShadow
                      .copyWith(color: StyleUtil.secondaryColor),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: PieChart(
                              PieChartData(
                                  sections: showingSections(categories)),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 125.w,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Indicator(
                                  color: categories[index].color,
                                  text: categories[index].name,
                                  isSquare: true,
                                  textColor: StyleUtil.primaryColor,
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(5),
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver: SliverGrid.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 4,
                          children:
                              List.generate(categories.length + 1, (index) {
                            if (index == categories.length)
                              return CategoryGridItem(categories[0],
                                  isInit: true);
                            else
                              return CategoryGridItem(categories[index]);
                          })),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<Category> list) {
    return List.generate(list.length, (index) {
      return PieChartSectionData(
          color: list[index].color,
          value: list[index].amount,
          title: list[index].amount.toString(),
          radius: 50,
          titleStyle: TextStyle(
              fontSize: 10.w,
              color: StyleUtil.primaryColor,
              fontFamily: "Prompt",
              fontWeight: FontWeight.bold),
          titlePositionPercentageOffset: 1.4);
    });
  }
}

class Category {
  String name;
  double amount;
  Color color;
  Category({required this.name, required this.amount, required this.color});
}
