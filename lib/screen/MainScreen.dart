import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/page/AboutPage.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: _buildDrawer(),
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [StyleUtil.primaryColor, Colors.yellow.shade700])),
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
                child: AboutPage(),
              )
            ],
          ),
        ),
      ),
    ));
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
                children: [
                  ListTile(
                    title: Text(
                      'First Menu Item',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Second Menu Item',
                      style: TextStyle(
                        color: StyleUtil.primaryColor,
                        fontSize: 25.w,
                        fontFamily: "Prompt",
                      ),
                    ),
                    onTap: () {},
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
                    onTap: () {},
                  ),
                ],
              ),
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
              onTap: () {
                print("logOut");
              },
            ),
          ],
        ),
      )),
    );
  }
}
