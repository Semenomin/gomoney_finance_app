import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gomoney_finance_app/screen/MainScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: StyleUtil.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      "GOMONEY",
                      style: TextStyle(
                          fontSize: 70.w,
                          fontFamily: "Prompt",
                          fontWeight: FontWeight.bold,
                          color: StyleUtil.secondaryColor),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  AppUtils.textForm(
                      "Email", _emailController, TextInputType.emailAddress),
                  AppUtils.textForm("Password", _passwordController,
                      TextInputType.visiblePassword),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 60.h,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            try {
                              GoogleSignIn _googleSignIn = GoogleSignIn();
                              await _googleSignIn.signIn();
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: InkWell(
                            onTap: () {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              String email = _emailController.text;
                              String password = _passwordController.text;
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: StyleUtil.rowndedBoxWithShadow
                                  .copyWith(
                                      color: StyleUtil.secondaryColor,
                                      borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                  child: Text(
                                "G",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.bold,
                                    color: StyleUtil.primaryColor),
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.secondaryColor),
                            child: Center(
                              child: Text("GO",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: "Prompt",
                                      fontWeight: FontWeight.bold,
                                      color: StyleUtil.primaryColor)),
                            ),
                          ),
                        )),
                        InkWell(
                          onTap: () async {
                            UserCredential userCredential =
                                await FirebaseAuth.instance.signInAnonymously();
                            GetIt.I<PreferencesService>()
                                .setToken(userCredential.user!.uid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
                                color: StyleUtil.secondaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: StyleUtil.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              AppUtils.emptyContainer(double.infinity, 20.h)
            ],
          ),
        ),
      ),
    );
  }
}
