import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/dialogs/AddUser.dart';
import 'package:gomoney_finance_app/page/CategoriesPage.dart';
import 'package:gomoney_finance_app/screen/CategoryScreen.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  final bool isInit;
  const CategoryGridItem(this.category, {this.isInit = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
        color: StyleUtil.secondaryColor,
      ),
      child: InkWell(
        onTap: () {
          !isInit
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryScreen(category)),
                )
              : AddUser(context, "ADD CATEGORY", () {}); //TODO
        },
        child: Column(
          children: [
            Expanded(
              child: !isInit
                  ? Icon(
                      LineIcons.sdCard,
                      color: category.color,
                      size: 40.r,
                    )
                  : Icon(
                      Icons.add,
                      color: StyleUtil.primaryColor,
                      size: 40.r,
                    ),
            ),
            Visibility(
              visible: !isInit,
              child: FittedBox(
                child: Text(
                  category.name,
                  style: TextStyle(
                      color: StyleUtil.primaryColor,
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
