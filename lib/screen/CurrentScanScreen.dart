import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';

class CurrentScanScreen extends StatefulWidget {
  final Scan scan;

  CurrentScanScreen({required this.scan});

  @override
  _CurrentScanScreenState createState() => _CurrentScanScreenState();
}

class _CurrentScanScreenState extends State<CurrentScanScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();

  @override
  void initState() {
    controller.text = widget.scan.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: StyleUtil.primaryColor,
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 60.r,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: double.infinity,
                            width: 60.r,
                            child: FittedBox(
                              child: Icon(
                                Icons.arrow_back,
                                color: StyleUtil.secondaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      GetIt.I<SqliteService>()
                          .updateDescription(controller.text, widget.scan.id);
                      BotToast.showText(text: "Saved");
                    },
                    child: Container(
                      height: 60.r,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: double.infinity,
                            width: 60.r,
                            child: FittedBox(
                              child: Icon(
                                Icons.save,
                                color: StyleUtil.secondaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          )))),
              ListTile(
                trailing: GestureDetector(
                    onTap: () {
                      controller.text = controller.text
                          .replaceAll(controllerFrom.text, controllerTo.text);
                    },
                    child: Icon(Icons.arrow_right,
                        color: StyleUtil.secondaryColor)),
                title: Text(
                  "Replace all",
                  style: TextStyle(
                      fontSize: 30.r,
                      fontFamily: "Prompt",
                      fontWeight: FontWeight.bold,
                      color: StyleUtil.secondaryColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                        child: AppUtils.textForm("from", controllerFrom,
                            TextInputType.text, StyleUtil.secondaryColor)),
                    VerticalDivider(),
                    Expanded(
                        child: AppUtils.textForm("to", controllerTo,
                            TextInputType.text, StyleUtil.secondaryColor))
                  ],
                ),
              ),
              Divider()
            ],
          ),
        ),
      )),
    );
  }
}
