import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gomoney_finance_app/screen/MainScreen.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: StyleUtil.primaryColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50.h,
                      width: 100.w,
                      child: InkWell(
                        onTap: () {
                          showRegisterSheet(context, "Register");
                        },
                        child: Container(
                          decoration: StyleUtil.rowndedBoxWithShadow
                              .copyWith(color: StyleUtil.secondaryColor),
                          child: Center(
                            child: Text("Register",
                                style: TextStyle(
                                    fontSize: 14.w,
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.bold,
                                    color: StyleUtil.primaryColor)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50.h,
                      width: 200.w,
                      child: InkWell(
                        onTap: () {
                          showForgetSheet(context, "Restore Password");
                        },
                        child: Container(
                          decoration: StyleUtil.rowndedBoxWithShadow
                              .copyWith(color: StyleUtil.secondaryColor),
                          child: Center(
                            child: Text("Forget your password?",
                                style: TextStyle(
                                    fontSize: 14.w,
                                    fontFamily: "Prompt",
                                    fontWeight: FontWeight.bold,
                                    color: StyleUtil.primaryColor)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        "GOMONEY",
                        style: TextStyle(
                            fontSize: 60.w,
                            fontFamily: "Prompt",
                            fontWeight: FontWeight.bold,
                            color: StyleUtil.secondaryColor),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    AppUtils.textForm("Email", _emailController,
                        TextInputType.emailAddress, StyleUtil.secondaryColor),
                    AppUtils.textForm(
                        "Password",
                        _passwordController,
                        TextInputType.visiblePassword,
                        StyleUtil.secondaryColor),
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
                              onTap: () async {
                                try {
                                  final GoogleSignInAccount googleUser =
                                      (await GoogleSignIn().signIn())!;
                                  final GoogleSignInAuthentication googleAuth =
                                      await googleUser.authentication;
                                  final OAuthCredential credential =
                                      GoogleAuthProvider.credential(
                                    accessToken: googleAuth.accessToken,
                                    idToken: googleAuth.idToken,
                                  );
                                  UserCredential userCredential =
                                      await FirebaseAuth.instance
                                          .signInWithCredential(credential);
                                  GetIt.I<PreferencesService>()
                                      .setToken(userCredential.user!.uid);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()),
                                  );
                                } catch (e) {
                                  BotToast.showText(text: "Wrong Auth");
                                }
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: StyleUtil.rowndedBoxWithShadow
                                    .copyWith(
                                        color: StyleUtil.secondaryColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                              child: InkWell(
                            onTap: () async {
                              try {
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: email, password: password);
                                GetIt.I<PreferencesService>()
                                    .setToken(userCredential.user!.uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  BotToast.showText(
                                      text: "No user found for that email.");
                                } else if (e.code == 'wrong-password') {
                                  BotToast.showText(
                                      text:
                                          "Wrong password provided for that user.");
                                } else {
                                  BotToast.showText(text: "Wrong Auth");
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                            ),
                          )),
                          InkWell(
                            onTap: () async {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInAnonymously();
                                GetIt.I<PreferencesService>()
                                    .setToken(userCredential.user!.uid);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  BotToast.showText(
                                      text: "No user found for that email.");
                                } else if (e.code == 'wrong-password') {
                                  BotToast.showText(
                                      text:
                                          "Wrong password provided for that user.");
                                } else {
                                  BotToast.showText(text: "Wrong Auth");
                                }
                              }
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: StyleUtil.rowndedBoxWithShadow
                                  .copyWith(
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
      ),
    );
  }

  Future showRegisterSheet(BuildContext context, String title) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return showMaterialModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          children: [
            AppUtils.emptyContainer(double.infinity, 70.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      AppUtils.emptyContainer(double.infinity, 20.h),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(title,
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 40.h,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Email", _emailController,
                          TextInputType.emailAddress, StyleUtil.primaryColor),
                      AppUtils.textForm(
                          "Password",
                          _passwordController,
                          TextInputType.visiblePassword,
                          StyleUtil.primaryColor),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            try {
                              String email = _emailController.text;
                              String password = _passwordController.text;
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              GetIt.I<PreferencesService>()
                                  .setToken(userCredential.user!.uid);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                BotToast.showText(
                                    text: "The password provided is too weak");
                              } else if (e.code == 'email-already-in-use') {
                                BotToast.showText(
                                    text:
                                        "The account already exists for that email");
                              }
                            } catch (e) {
                              BotToast.showText(text: "Wrong Register");
                            }
                          },
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.primaryColor),
                            child: Center(
                              child: Text("GO",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: "Prompt",
                                      fontWeight: FontWeight.bold,
                                      color: StyleUtil.secondaryColor)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future showForgetSheet(BuildContext context, String title) {
    TextEditingController _emailController = TextEditingController();
    return showMaterialModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          children: [
            AppUtils.emptyContainer(double.infinity, 70.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: StyleUtil.secondaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      AppUtils.emptyContainer(double.infinity, 20.h),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(title,
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 30.w,
                                color: StyleUtil.primaryColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      AppUtils.textForm("Email", _emailController,
                          TextInputType.emailAddress, StyleUtil.primaryColor),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            try {
                              String email = _emailController.text;
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);
                              Navigator.pop(context);
                              BotToast.showText(text: "Check your email");
                            } catch (e) {
                              BotToast.showText(text: "Wrong Email");
                            }
                          },
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.primaryColor),
                            child: Center(
                              child: Text("GO",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontFamily: "Prompt",
                                      fontWeight: FontWeight.bold,
                                      color: StyleUtil.secondaryColor)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
