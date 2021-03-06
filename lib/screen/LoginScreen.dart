import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddName.dart';
import 'package:gomoney_finance_app/dialogs/RegisterAndLogin.dart';
import 'package:gomoney_finance_app/model/index.dart' as model;
import 'package:gomoney_finance_app/dialogs/RestorePassword.dart';
import 'package:gomoney_finance_app/service/BackupService.dart';
import 'package:gomoney_finance_app/service/FCMservice.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gomoney_finance_app/screen/MainScreen.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:line_icons/line_icons.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: StyleUtil.primaryColor,
          child: SafeArea(
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                color: StyleUtil.primaryColor,
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        constraints:
                            BoxConstraints(maxWidth: 170, maxHeight: 80),
                        height: 50.h,
                        width: 100.w,
                        child: InkWell(
                          onTap: () {
                            RegisterAndLogin(
                              context,
                              "Register",
                              (emailController, passwordController,
                                  nameController) async {
                                try {
                                  String email = emailController.text;
                                  String name = nameController.text;
                                  String password = passwordController.text;
                                  UserCredential userCredential =
                                      await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                              email: email, password: password);
                                  GetIt.I<PreferencesService>()
                                      .setToken(userCredential.user!.uid);
                                  GetIt.I<PreferencesService>().setName(name);
                                  GetIt.I<SqliteService>().addUser(model.User(
                                    id: userCredential.user!.uid,
                                    pushId: (GetIt.I<FcmService>().token)!,
                                    amountOfMoney: 0.0,
                                    name: name,
                                  ));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen()),
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    BotToast.showText(
                                        text:
                                            "The password provided is too weak");
                                  } else if (e.code == 'email-already-in-use') {
                                    BotToast.showText(
                                        text:
                                            "The account already exists for that email");
                                  }
                                } catch (e) {
                                  BotToast.showText(text: "Wrong Register");
                                }
                              },
                            );
                          },
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.secondaryColor),
                            child: Center(
                              child: Text("Register",
                                  style: TextStyle(
                                      fontSize: 14.r,
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
                        constraints:
                            BoxConstraints(maxWidth: 360, maxHeight: 80),
                        height: 50.h,
                        width: 200.w,
                        child: InkWell(
                          onTap: () =>
                              RestorePassword(context, "Restore Password"),
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.secondaryColor),
                            child: Center(
                              child: Text("Forgot your password?",
                                  style: TextStyle(
                                      fontSize: 14.r,
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
                              fontSize: 60.r,
                              fontFamily: "Prompt",
                              fontWeight: FontWeight.bold,
                              color: StyleUtil.secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 380.r),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.r),
                          child: AppUtils.textForm(
                              "Email",
                              _emailController,
                              TextInputType.emailAddress,
                              StyleUtil.secondaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.r),
                          child: AppUtils.textForm(
                              "Password",
                              _passwordController,
                              TextInputType.visiblePassword,
                              StyleUtil.secondaryColor),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 60.r,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  try {
                                    GoogleSignIn sign = GoogleSignIn.standard(
                                        scopes: [DriveApi.driveScope]);
                                    final GoogleSignInAccount googleUser =
                                        (await sign.signIn())!;
                                    final GoogleSignInAuthentication
                                        googleAuth =
                                        await googleUser.authentication;
                                    final OAuthCredential credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );
                                    GetIt.I<BackupService>().sign = sign;
                                    UserCredential userCredential =
                                        await FirebaseAuth.instance
                                            .signInWithCredential(credential);
                                    GetIt.I<PreferencesService>()
                                        .setToken(userCredential.user!.uid);
                                    AddName(context, "ADD NAME",
                                        (nameController) {
                                      GetIt.I<PreferencesService>()
                                          .setName(nameController.text);
                                      GetIt.I<SqliteService>()
                                          .addUser(model.User(
                                        id: userCredential.user!.uid,
                                        pushId: (GetIt.I<FcmService>().token)!,
                                        amountOfMoney: 0.0,
                                        name: nameController.text,
                                      ));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MainScreen()),
                                      );
                                    });
                                  } catch (e) {
                                    BotToast.showText(text: "Wrong Auth");
                                  }
                                },
                                child: Container(
                                  width: 60.r,
                                  height: 60.r,
                                  decoration: StyleUtil.rowndedBoxWithShadow
                                      .copyWith(
                                          color: StyleUtil.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(50.r)),
                                  child: Icon(
                                    LineIcons.googleLogo,
                                    size: 40.r,
                                    color: StyleUtil.primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      String email = _emailController.text;
                                      String password =
                                          _passwordController.text;
                                      UserCredential userCredential =
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                      GetIt.I<PreferencesService>()
                                          .setToken(userCredential.user!.uid);
                                      AddName(context, "ADD NAME",
                                          (nameController) {
                                        GetIt.I<PreferencesService>()
                                            .setName(nameController.text);
                                        GetIt.I<SqliteService>()
                                            .addUser(model.User(
                                          id: userCredential.user!.uid,
                                          pushId:
                                              (GetIt.I<FcmService>().token)!,
                                          amountOfMoney: 0.0,
                                          name: nameController.text,
                                        ));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()),
                                        );
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        BotToast.showText(
                                            text:
                                                "No user found for that email.");
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Container(
                                      decoration: StyleUtil.rowndedBoxWithShadow
                                          .copyWith(
                                              color: StyleUtil.secondaryColor),
                                      child: Center(
                                        child: Text("GO",
                                            style: TextStyle(
                                                fontSize: 35.r,
                                                fontFamily: "Prompt",
                                                fontWeight: FontWeight.bold,
                                                color: StyleUtil.primaryColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  AppUtils.emptyContainer(double.infinity, 20.h)
                ]),
              ),
            ),
          ),
        ));
  }
}
