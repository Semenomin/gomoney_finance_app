import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  final bool isInit;
  final Function onTap;
  const CategoryGridItem(this.category,
      {this.isInit = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
        color: StyleUtil.secondaryColor,
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          children: [
            Expanded(
              child: !isInit
                  ? Icon(
                      category.icon,
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
                      fontSize: 12.r,
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
