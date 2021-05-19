import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/PlannedPage/PlannedCard.dart';

class PlannedPage extends StatefulWidget {
  @override
  _PlannedPageState createState() => _PlannedPageState();
}

class _PlannedPageState extends State<PlannedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView(
          children: [PlannedCard()],
        )),
        Container(
          height: 80.r,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Container(
                    decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        "INCOME",
                        style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 30.r,
                            color: StyleUtil.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Container(
                    decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        "EXPENSE",
                        style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 30.r,
                            color: StyleUtil.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
