import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/dialogs/AddAmount.dart';
import 'package:gomoney_finance_app/dialogs/AddNameAndAmount.dart';
import 'package:gomoney_finance_app/dialogs/AreYouSure.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/model/index.dart';
import 'package:gomoney_finance_app/service/PreferencesService.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:uuid/uuid.dart';

class BoxCard extends StatelessWidget {
  final bool isPlus;
  final MoneyBox? box;
  final String currensy;
  final Function? update;
  final int? selectedPage;
  const BoxCard(
      {this.box,
      required this.currensy,
      this.isPlus = false,
      this.update,
      this.selectedPage});

  @override
  Widget build(BuildContext context) {
    if (!isPlus) {
      return InkWell(
        onLongPress: () {
          AreYouSure(context, "ARE YOU SURE?", () {
            GetIt.I<SqliteService>().deleteMoneyBox(box!);
            update!(selectedPage! - 1);
            Navigator.pop(context);
          });
        },
        onTap: () async {
          AddAmount(context, "ADD MONEY", (controller) {
            if (controller.text.contains(",")) {
              controller.text = controller.text.replaceAll(",", ".");
            }
            GetIt.I<SqliteService>().addTransaction(
                FinTransaction(
                    id: Uuid().v4(),
                    name: "Box " + box!.name + " Add",
                    isIncome: false,
                    date: DateTime.now(),
                    currency: "",
                    moneyBoxId: box!.id,
                    amountOfMoney: double.parse(controller.text)),
                moneyBox: box);
            update!(selectedPage);
            Navigator.pop(context);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/piggy.svg',
              ),
              Text(
                box!.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Prompt",
                    fontSize: 20.r,
                    color: StyleUtil.secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 45.r, top: 35.r),
                child: Center(
                    child: Container(
                  width: 150.r,
                  child: Text(
                    box!.amountOfMoney.toString() +
                        " / \n" +
                        box!.aim.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Prompt",
                        fontSize: 20.r,
                        color: StyleUtil.secondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                )),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  box!.currency,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Prompt",
                      fontSize: 20.r,
                      color: StyleUtil.secondaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return InkWell(
        onTap: () => AddNameAndAmount(context, "ADD BOX", update,
            (controllerName, controllerAmount) {
          if (controllerAmount.text.contains(",")) {
            controllerAmount.text.replaceAll(",", ".");
          }
          var amount = double.tryParse(controllerAmount.text);
          if (amount != null) {
            GetIt.I<SqliteService>().addMoneyBox(MoneyBox(
                id: Uuid().v4(),
                name: controllerName.text,
                amountOfMoney: 0.0,
                aim: double.parse(controllerAmount.text),
                userId: GetIt.I<PreferencesService>().getToken(),
                currency: GetIt.I<PreferencesService>().getCurrency()));
            update!(selectedPage! + 1);
            Navigator.pop(context);
          } else {
            BotToast.showText(text: "Wrong Amount");
          }
        }),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/piggy.svg',
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.r, top: 25.r),
                child: Center(
                    child: Icon(Icons.add,
                        color: StyleUtil.secondaryColor, size: 60.r)),
              ),
            ],
          ),
        ),
      );
  }
}
