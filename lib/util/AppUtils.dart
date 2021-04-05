import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'StyleUtils.dart';

class AppUtils {
  static Widget emptyContainer(double width, double height) {
    return Container(width: width, height: height);
  }

  static Widget textForm(
      String hint, TextEditingController controller, TextInputType textType) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Theme(
        data: ThemeData(
          primaryColor: StyleUtil.secondaryColor,
        ),
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
              fontFamily: "Prompt",
            )),
      ),
    );
  }
}
