import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import '../../Enums.dart';

class DebtHistoryListTile extends StatelessWidget {
  final OperationType type;
  final String name;
  final DateTime date;
  final double amount;
  final String currency;
  const DebtHistoryListTile(
      {required this.type,
      required this.name,
      required this.date,
      required this.amount,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Row(
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 30.r,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.bold,
                        color: StyleUtil.secondaryColor)),
                Expanded(child: Container()),
                Icon(
                  type == OperationType.EXPENSE
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: StyleUtil.secondaryColor,
                  size: 30.r,
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(date.toString().substring(0, 19),
                    style: TextStyle(
                        fontSize: 13.r, color: StyleUtil.secondaryColor)),
                Expanded(child: Container()),
                Text(amount.toString() + " " + currency,
                    style: TextStyle(
                        fontSize: 15.r,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.bold,
                        color: StyleUtil.secondaryColor)),
              ],
            ),
            onTap: () {}),
        Divider()
      ],
    );
  }
}
