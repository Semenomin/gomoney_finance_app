import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gomoney_finance_app/widget/CircularProgressGO.dart';

class LoadingPage extends StatefulWidget {
  final Color color;
  LoadingPage(this.color);
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    controller!.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressGO(controller: controller!, color: widget.color),
    );
  }
}
