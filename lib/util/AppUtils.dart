import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppUtils {
  static Widget emptyContainer(double width, double height) {
    return Container(width: width, height: height);
  }

  static Widget textForm(String hint, TextEditingController controller,
      TextInputType textType, Color color) {
    return Container(
      height: 65.r,
      constraints: BoxConstraints(maxWidth: 390.r),
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Theme(
        data: ThemeData(primaryColor: color, hintColor: color),
        child: TextFormField(
            controller: controller,
            keyboardType: textType,
            obscureText:
                textType == TextInputType.visiblePassword ? true : false,
            decoration: new InputDecoration(
              labelText: hint,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            style: TextStyle(
              fontSize: 15.r,
              fontFamily: "Prompt",
              color: color,
            )),
      ),
    );
  }
}
