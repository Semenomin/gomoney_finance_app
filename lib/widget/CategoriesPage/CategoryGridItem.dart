import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/RenameOrDelete.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  final bool isInit;
  final Function onTap;
  final Function? update;
  const CategoryGridItem(this.category,
      {this.isInit = false, required this.onTap, this.update});

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
        onLongPress: () {
          if (!isInit) {
            RenameOrDelete(context, (controller) {
              category.name = controller.text;
              GetIt.I<SqliteService>().changeCategoryName(category);
              update!();
              Navigator.pop(context);
            }, () {
              GetIt.I<SqliteService>().deleteCategory(category);
              update!();
              Navigator.pop(context);
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: !isInit
                  ? Icon(
                      LineIcons.values[category.icon],
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
