import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PackageInfoService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:line_icons/line_icons.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 250.h,
            child: Container(
              child: Center(
                child: Text(
                  "GOMONEY",
                  style: TextStyle(
                      fontSize: 55.w,
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold,
                      color: StyleUtil.secondaryColor),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              decoration: BoxDecoration(
                  color: StyleUtil.secondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, -5),
                        blurRadius: 10,
                        color: Colors.black38)
                  ]),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AppUtils.emptyContainer(double.infinity, 20.h),
                        ListTile(
                          title: Text(
                            "App : " +
                                GetIt.I<PackageInfoService>()
                                    .packageInfo!
                                    .appName,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Prompt",
                                color: StyleUtil.primaryColor),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Version : " +
                                GetIt.I<PackageInfoService>()
                                    .packageInfo!
                                    .version,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Prompt",
                                color: StyleUtil.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.facebook,
                              size: 40.0,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.github,
                              size: 40.0,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.instagram,
                              size: 40.0,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.linkedin,
                              size: 40.0,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
