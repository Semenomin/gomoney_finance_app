import 'package:bot_toast/bot_toast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/screen/CategoryScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/CategoriesPage/CategoryGridItem.dart';
import 'package:gomoney_finance_app/widget/Indicator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uuid/uuid.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int? touchedIndex;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I<SqliteService>().getUserCategorys(),
      builder: (context, AsyncSnapshot<List<Category>> categorys) {
        if (categorys.hasData) {
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
                                child: categorys.data!.length > 0
                                    ? Container(
                                        padding: EdgeInsets.all(0.r),
                                        child: Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: PieChart(
                                            PieChartData(
                                                sections: showingSections(
                                                    categorys.data!)),
                                            swapAnimationDuration: Duration(
                                                milliseconds: 150), // Optional
                                            swapAnimationCurve:
                                                Curves.linear, // Optional
                                          ),
                                        ),
                                      )
                                    : Container()),
                            Container(
                              width: 125.r,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: categorys.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Indicator(
                                        color: categorys.data![index].color,
                                        text: categorys.data![index].name,
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
                                children: List.generate(
                                    categorys.data!.length + 1, (index) {
                                  if (index == categorys.data!.length)
                                    return CategoryGridItem(
                                        Category(
                                            icon: "code",
                                            amountOfMoney: 223,
                                            name: "fef",
                                            color: Colors.white,
                                            id: "dwdwdwdw"),
                                        isInit: true, onTap: () {
                                      AddName(context, "ADD CATEGORY",
                                          (controller) {
                                        if (controller.text != "") {
                                          GetIt.I<SqliteService>().addCategory(
                                              Category(
                                                  id: Uuid().v4(),
                                                  userId: GetIt.I<
                                                          PreferencesService>()
                                                      .getToken(),
                                                  name: controller.text,
                                                  amountOfMoney: 0.0,
                                                  color: Colors.white,
                                                  icon: "ban"));
                                          update();
                                          Navigator.pop(context);
                                        } else {
                                          BotToast.showText(
                                              text: "Set name, please!");
                                        }
                                      });
                                    });
                                  else
                                    return CategoryGridItem(
                                        categorys.data![index],
                                        update: update, onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen(
                                                    categorys.data![index])),
                                      ).then((value) => setState(() {}));
                                    });
                                })),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        } else
          return LoadingPage(StyleUtil.secondaryColor);
      },
    );
  }

  void update() {
    setState(() {});
  }

  List<PieChartSectionData> showingSections(List<Category> list) {
    List<PieChartSectionData> res = [];
    for (var item in list) {
      if (item.amountOfMoney != 0.0) {
        res.add(PieChartSectionData(
            color: item.color,
            value: -item.amountOfMoney,
            title: (-item.amountOfMoney).toString(),
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 10.w,
                color: StyleUtil.primaryColor,
                fontFamily: "Prompt",
                fontWeight: FontWeight.bold),
            titlePositionPercentageOffset: 1.4));
      }
    }
    return res;
  }
}
