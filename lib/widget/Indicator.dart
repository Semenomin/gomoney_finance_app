import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final Color textColor;

  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 16.r,
          height: 16.r,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 13.r, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
