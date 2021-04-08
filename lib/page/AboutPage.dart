import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/service/PackageInfoService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      fontSize: 55.r,
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold,
                      color: StyleUtil.secondaryColor),
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                  color: StyleUtil.secondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.r),
                      topRight: Radius.circular(60.r)),
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
                        AppUtils.emptyContainer(double.infinity, 20.r),
                        ListTile(
                          title: Text(
                            "App : " +
                                GetIt.I<PackageInfoService>()
                                    .packageInfo!
                                    .appName,
                            style: TextStyle(
                                fontSize: 20.r,
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
                                fontSize: 20.r,
                                fontFamily: "Prompt",
                                color: StyleUtil.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 12.r),
                    child: Row(
                      children: [
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () async => await canLaunch(
                              "https://www.telegram.me/Semenomin",
                            )
                                ? await launch(
                                    "https://www.telegram.me/Semenomin",
                                    forceSafariVC: false)
                                : BotToast.showText(text: "Wrong Link"),
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.telegram,
                              size: 40.0.r,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0.r),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () async => await canLaunch(
                              "https://github.com/Semenomin",
                            )
                                ? await launch("https://github.com/Semenomin",
                                    forceSafariVC: false)
                                : BotToast.showText(text: "Wrong Link"),
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.github,
                              size: 40.0.r,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0.r),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () async => await canLaunch(
                              "https://www.instagram.com/semenomin_official/",
                            )
                                ? await launch(
                                    "https://www.instagram.com/semenomin_official/",
                                    forceSafariVC: false)
                                : BotToast.showText(text: "Wrong Link"),
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.instagram,
                              size: 40.0.r,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0.r),
                            shape: CircleBorder(),
                          ),
                        ),
                        Expanded(
                          child: RawMaterialButton(
                            onPressed: () async => await canLaunch(
                              "https://by.linkedin.com/in/semen-pilik-8693aa188?trk=public_profile_browsemap_profile-result-card_result-card_full-click",
                            )
                                ? await launch(
                                    "https://by.linkedin.com/in/semen-pilik-8693aa188?trk=public_profile_browsemap_profile-result-card_result-card_full-click",
                                    forceSafariVC: false)
                                : BotToast.showText(text: "Wrong Link"),
                            elevation: 4.0,
                            fillColor: StyleUtil.primaryColor,
                            child: Icon(
                              LineIcons.linkedin,
                              size: 40.0.r,
                              color: StyleUtil.secondaryColor,
                            ),
                            padding: EdgeInsets.all(10.0.r),
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
