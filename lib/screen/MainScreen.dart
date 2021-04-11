import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/page/AboutPage.dart';
import 'package:gomoney_finance_app/page/CategoriesPage.dart';
import 'package:gomoney_finance_app/page/ChartsPage.dart';
import 'package:gomoney_finance_app/page/DebtsPage.dart';
import 'package:gomoney_finance_app/page/HomePage.dart';
import 'package:gomoney_finance_app/page/SettingsPage.dart';
import 'package:gomoney_finance_app/screen/LoginScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
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
                  ),
                  Expanded(
                    child: _page,
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildDrawer() {
    return ClipRRect(
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
                    fontSize: 25.w,
                    fontFamily: "Prompt",
                    fontWeight: FontWeight.bold),
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
                    ),
                    onTap: () {
                      setState(() {
                        _page = CategoriesPage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Charts',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _page = ChartsPage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Debts',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _page = DebtsPage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _page = SettingsPage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'About',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _page = AboutPage();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
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
                    flex: 6,
                    child: Text(
                      'User Namewwwwwwwwwwwwwwwwww',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Prompt",
                      ),
                    ),
                  ),
                  Expanded(child: Container(width: 5.r)),
                  Flexible(
                    flex: 4,
                    child: Text(
                      '2000000' + " RUB",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 15.r,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Prompt",
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () async {},
            ),
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
                      fontSize: 15.w,
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
    );
  }
}
