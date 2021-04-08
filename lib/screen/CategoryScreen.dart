import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/page/CategoriesPage.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:o_color_picker/o_color_picker.dart';

import 'ChooseIconScreen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  CategoryScreen(this.category);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
                      height: 60.h,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: double.infinity,
                            width: 60.h,
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
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
                          color: widget.category.color,
                          borderRadius: BorderRadius.circular(100)),
                      height: 60.h,
                      width: 115.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChooseIconScreen()),
                                  );
                                },
                                child: Container(
                                  height: 60.h,
                                  child: Icon(LineIcons.accessibleIcon,
                                      size: 35.w),
                                )),
                          ),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Material(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            OColorPicker(
                                              selectedColor:
                                                  widget.category.color,
                                              colors: primaryColorsPalette,
                                              onColorChange: (color) {
                                                setState(() {
                                                  widget.category.color = color;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 60.h,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              )
            ],
          ),
        ),
      )),
    );
  }
}
