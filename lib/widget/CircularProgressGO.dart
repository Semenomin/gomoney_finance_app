import 'package:flutter/widgets.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class CircularProgressGO extends StatelessWidget {
  const CircularProgressGO({required this.controller, required this.color});
  final Color color;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: RotationTransition(
          turns: controller,
          child: SizedBox(
              width: 50,
              height: 50,
              child: FittedBox(
                child: Text(
                  "GO",
                  style: TextStyle(
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold,
                      color: color,
                      decoration: TextDecoration.none),
                ),
              )),
        )),
      ],
    );
  }
}
