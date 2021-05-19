import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtHistoryListTile.dart';
import 'package:gomoney_finance_app/widget/MoneyBoxScreen/BoxCard.dart';

import '../Enums.dart';
import 'LoadingPage.dart';

class MoneyBoxPage extends StatefulWidget {
  @override
  _MoneyBoxPageState createState() => _MoneyBoxPageState();
}

class _MoneyBoxPageState extends State<MoneyBoxPage> {
  PageController _cardController = PageController(initialPage: 0);
  int _selectedCard = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<SqliteService>().getAllMoneyBoxes(),
        builder: (context, AsyncSnapshot<List<MoneyBox>> moneyBoxes) {
          if (moneyBoxes.hasData) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (pageIndex) {
                      setState(() {
                        _selectedCard = pageIndex;
                      });
                    },
                    controller: _cardController,
                    scrollDirection: Axis.horizontal,
                    itemCount: moneyBoxes.data!.length + 1,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return BoxCard(
                            currensy: "RUB",
                            isPlus: true,
                            update: update,
                            selectedPage: _selectedCard,
                          );
                        default:
                          return BoxCard(
                              currensy: "RUB",
                              box: moneyBoxes.data!.elementAt(index - 1),
                              update: update,
                              selectedPage: _selectedCard);
                      }
                    },
                  )),
                  Expanded(
                      flex: 2,
                      child: _selectedCard >= 1
                          ? FutureBuilder(
                              future: GetIt.I<SqliteService>().getTransactions(
                                  moneyBox:
                                      moneyBoxes.data![_selectedCard - 1]),
                              builder: (context,
                                  AsyncSnapshot<List<FinTransaction>>
                                      transactions) {
                                if (transactions.hasData) {
                                  return ListView.builder(
                                      itemCount: transactions.data!.length,
                                      itemBuilder: (context, index) {
                                        return DebtHistoryListTile(
                                            type: transactions
                                                    .data![transactions
                                                            .data!.length -
                                                        index -
                                                        1]
                                                    .isIncome
                                                ? TransactionType.INCOME
                                                : TransactionType.EXPENSE,
                                            name: transactions
                                                .data![transactions
                                                        .data!.length -
                                                    index -
                                                    1]
                                                .name,
                                            date: transactions
                                                .data![
                                                    transactions
                                                            .data!.length -
                                                        index -
                                                        1]
                                                .date,
                                            amount: transactions
                                                .data![
                                                    transactions.data!.length -
                                                        index -
                                                        1]
                                                .amountOfMoney,
                                            currency: "RUB");
                                      });
                                } else
                                  return Center(
                                      child: LoadingPage(
                                          StyleUtil.secondaryColor));
                              })
                          : Container()),
                ],
              ),
            );
          } else
            return Center(child: LoadingPage(StyleUtil.secondaryColor));
        });
  }

  void update(int page) {
    setState(() {
      _selectedCard = page;
    });
  }
}
