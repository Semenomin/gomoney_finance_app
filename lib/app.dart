import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/screen/LoginScreen.dart';
import 'package:gomoney_finance_app/screen/MainScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class MyApp extends StatelessWidget {
  final botToastBuilder = BotToastInit();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ScreenUtilInit(
                  designSize: Size(360, 690),
                  allowFontScaling: false,
                  builder: () => FutureBuilder(
                      future: GetIt.I.allReady(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return MaterialApp(
                            title: 'Flutter Demo',
                            theme: ThemeData(
                                primaryColor: StyleUtil.primaryColor,
                                canvasColor: Colors.transparent),
                            home:
                                GetIt.I<PreferencesService>().getToken() == null
                                    ? LoginScreen()
                                    : MainScreen(),
                          );
                        } else
                          return MaterialApp(
                              color: Colors.white,
                              home: Container(
                                  color: Colors.white,
                                  child: Center(
                                      child: CircularProgressIndicator())));
                      }));
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
