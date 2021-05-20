import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/screen/LoginScreen.dart';
import 'package:gomoney_finance_app/screen/MainScreen.dart';
import 'package:gomoney_finance_app/service/IsolateService.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class MyApp extends StatelessWidget {
  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    if (GetIt.I<PreferencesService>().getToken() != null) {
      GetIt.I<IsolateService>().followPlanned();
      GetIt.I<IsolateService>().followBackup();
    }
    return GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: ScreenUtilInit(
            designSize: Size(360, 690),
            builder: () => FutureBuilder(
                future: GetIt.I.allReady(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return MaterialApp(
                      builder: (context, child) {
                        child = botToastBuilder(context, child);
                        return child;
                      },
                      title: 'Flutter Demo',
                      theme: ThemeData(
                          primaryColor: StyleUtil.primaryColor,
                          canvasColor: Colors.transparent),
                      home: GetIt.I<PreferencesService>().getToken() == null
                          ? LoginScreen()
                          : MainScreen(),
                    );
                  } else
                    return MaterialApp(
                        color: StyleUtil.primaryColor,
                        home: Container(
                            color: StyleUtil.primaryColor,
                            child: Center(
                                child: LoadingPage(StyleUtil.secondaryColor))));
                })));
  }
}
