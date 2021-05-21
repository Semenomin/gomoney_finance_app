import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class ChooseIconScreen extends StatelessWidget {
  final Category category;
  ChooseIconScreen(this.category);

  bool isMenuFixed(BuildContext context) {
    return MediaQuery.of(context).size.width > 500;
  }

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
              Row(
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
                ],
              ),
              Expanded(
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
                            crossAxisCount: isMenuFixed(context) ? 7 : 4,
                            children: List.generate(
                                LineIcons.values.keys.length, (index) {
                              return InkWell(
                                onTap: () {
                                  GetIt.I<SqliteService>().changeCategoryIcon(
                                      category,
                                      LineIcons.values.keys.elementAt(index));
                                  Navigator.pop(context,
                                      LineIcons.values.keys.elementAt(index));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: StyleUtil.rowndedBoxWithShadow
                                      .copyWith(
                                          color: StyleUtil.secondaryColor),
                                  child: Icon(
                                    LineIcons.values[
                                        LineIcons.values.keys.elementAt(index)],
                                    size: 45.r,
                                    color: StyleUtil.primaryColor,
                                  ),
                                ),
                              );
                            })),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
