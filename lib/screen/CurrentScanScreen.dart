import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class CurrentScanScreen extends StatefulWidget {
  final Scan scan;

  CurrentScanScreen({required this.scan});

  @override
  _CurrentScanScreenState createState() => _CurrentScanScreenState();
}

class _CurrentScanScreenState extends State<CurrentScanScreen> {
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
              Expanded(
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(child: Text(widget.scan.description)))),
            ],
          ),
        ),
      )),
    );
  }
}
