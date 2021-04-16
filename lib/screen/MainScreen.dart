import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/User.dart' as model;
import 'package:gomoney_finance_app/page/AboutPage.dart';
import 'package:gomoney_finance_app/page/CategoriesPage.dart';
import 'package:gomoney_finance_app/page/ChartsPage.dart';
import 'package:gomoney_finance_app/page/DebtsPage.dart';
import 'package:gomoney_finance_app/page/HomePage.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/page/ProfilePage.dart';
import 'package:gomoney_finance_app/page/SettingsPage.dart';
import 'package:gomoney_finance_app/screen/LoginScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

bool isMenuFixed(BuildContext context) {
  return MediaQuery.of(context).size.width > 500;
}

class _MainScreenState extends State<MainScreen> {
  Widget _page = SettingsPage();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: StyleUtil.primaryColor,
        child: SafeArea(
            child: Scaffold(
          onDrawerChanged: (bo) {
            setState(() {});
          },
          drawerScrimColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          drawer: _buildDrawer(),
          body: Builder(
            builder: (context) => Container(
              color: StyleUtil.primaryColor,
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
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
                                Icons.menu,
                                color: StyleUtil.secondaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      color: StyleUtil.primaryColor,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Drawer(
            child: Container(
          decoration: BoxDecoration(
              color: StyleUtil.secondaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'GOMONEY',
                  style: TextStyle(
                      color: StyleUtil.primaryColor,
                      fontSize: 25.r,
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(
                      'Home',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _page = HomePage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Categories',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                      onTap: () {
                        setState(() {
                          _page = CategoriesPage();
                        });
                        if (!isMenuFixed(context)) Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Charts',
                        style: TextStyle(
                          color: StyleUtil.primaryColor,
                          fontSize: 25.r,
                          fontFamily: "Prompt",
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _page = ChartsPage();
                        });
                        if (!isMenuFixed(context)) Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Debts',
                        style: TextStyle(
                          color: StyleUtil.primaryColor,
                          fontSize: 25.r,
                          fontFamily: "Prompt",
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _page = DebtsPage();
                        });
                        if (!isMenuFixed(context)) Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          color: StyleUtil.primaryColor,
                          fontSize: 25.r,
                          fontFamily: "Prompt",
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _page = SettingsPage();
                        });
                        if (!isMenuFixed(context)) Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'About',
                        style: TextStyle(
                          color: StyleUtil.primaryColor,
                          fontSize: 25.r,
                          fontFamily: "Prompt",
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _page = AboutPage();
                        });
                        if (!isMenuFixed(context)) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.person,
                      color: StyleUtil.primaryColor,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      GetIt.I<PreferencesService>().getName()!,
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Prompt",
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Flexible(
                    child: FutureBuilder(
                        future: GetIt.I<SqliteService>().getUser(),
                        builder: (context, AsyncSnapshot<model.User> user) {
                          if (user.hasData) {
                            return Text(
                              user.data!.amountOfMoney.toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: StyleUtil.primaryColor,
                                fontSize: 15.r,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Prompt",
                              ),
                            );
                          } else
                            return LoadingPage(StyleUtil.primaryColor);
                        }),
                  ),
                ],
              ),
              onTap: () async {
                setState(() {
                  _page = ProfilePage();
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: StyleUtil.primaryColor,
                  ),
                  Text(
                    'LogOut',
                    style: TextStyle(
                      color: StyleUtil.primaryColor,
                    ),
                    Text(
                      'LogOut',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 15.r,
                        fontFamily: "Prompt",
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  GetIt.I<PreferencesService>().deleteToken();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
