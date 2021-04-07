import 'package:flutter/material.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/widget/debtScreen/DebtCard.dart';
import 'package:gomoney_finance_app/widget/debtScreen/DebtHistoryListTile.dart';

class DebtsPage extends StatefulWidget {
  @override
  _DebtsPageState createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  PageController _cardController = PageController(initialPage: 1);
  List<String> names = [
    "Semen Pilik",
    "Anna Alymova",
    "Yan Pershay",
    "Pavel Skomartsov"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: PageView.builder(
            onPageChanged: (pageIndex) {
              //TODO
            },
            controller: _cardController,
            scrollDirection: Axis.horizontal,
            itemCount: names.length + 2,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return DebtCard(
                    name: "All",
                    income: 200,
                    expense: 20000,
                    currensy: "RUB",
                    isInitial: true,
                    isPlus: true,
                  );
                case 1:
                  return DebtCard(
                    name: "All",
                    income: 200,
                    expense: 20000,
                    currensy: "RUB",
                    isInitial: true,
                  );
                default:
                  return DebtCard(
                      //TODO
                      name: names[index - 2],
                      income: 200,
                      expense: 2,
                      currensy: "RUB");
              }
            },
          )),
          Expanded(
              flex: 3,
              child: ListView.builder(
                //Todo
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return DebtHistoryListTile(
                    type: OperationType.EXPENSE,
                    name: names[index],
                    date: DateTime.now(),
                    amount: 2000,
                    currency: "RUB",
                  );
                },
              ))
        ],
      ),
    );
  }
}
