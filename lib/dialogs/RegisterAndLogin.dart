import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterAndLogin {
  RegisterAndLogin(
      context,
      title,
      void onTap(
          TextEditingController emailController,
          TextEditingController passwordController,
          TextEditingController nameController)) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        child: AppUtils.textForm("Email", _emailController,
                            TextInputType.emailAddress, StyleUtil.primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        child: AppUtils.textForm(
                            "Password",
                            _passwordController,
                            TextInputType.visiblePassword,
                            StyleUtil.primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        child: AppUtils.textForm("Name", _nameController,
                            TextInputType.text, StyleUtil.primaryColor),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () => onTap(_emailController,
                              _passwordController, _nameController),
                          child: Container(
                            decoration: StyleUtil.rowndedBoxWithShadow
                                .copyWith(color: StyleUtil.primaryColor),
                            child: Center(
                              child: Text("GO",
                                  style: TextStyle(
                                      fontSize: 40.r,
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
