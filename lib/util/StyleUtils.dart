import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StyleUtil {
  static Color primaryColor = Color(0xFFFFD038);
  static Color secondaryColor = Color.fromRGBO(8, 49, 59, 1);
  static BoxDecoration rowndedBoxWithShadow = BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black26)
    ],
  );
}
