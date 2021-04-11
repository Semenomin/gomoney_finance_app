import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/model/Debtor.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtCard.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtHistoryListTile.dart';

class DebtsPage extends StatefulWidget {
  @override
  _DebtsPageState createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  PageController _cardController = PageController(initialPage: 1);
  int _selectedCard = 1;
  _DebtsPageState();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<SqliteService>().getAllDebtors(),
        builder: (context, AsyncSnapshot<List<Debtor>> debtors) {
          if (debtors.hasData) {
            double allLendAmount = 0;
            double allBorrowAmount = 0;
            for (Debtor debtor in debtors.data!) {
              allLendAmount += debtor.lendAmount;
              allBorrowAmount += debtor.borrowAmount;
            }
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
                    itemCount: debtors.data!.length + 2,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return DebtCard(
                            currensy: "RUB",
                            isPlus: true,
                            isInitial: true,
                            update: update,
                            selectedPage: _selectedCard,
                          );
                        case 1:
                          return DebtCard(
                              currensy: "RUB",
                              isInitial: true,
                              debtor: Debtor(
                                id: "dwdww",
                                name: "ALL",
                                lendAmount: allLendAmount,
                                borrowAmount: allBorrowAmount,
                              ),
                              update: update,
                              selectedPage: _selectedCard);
                        default:
                          return DebtCard(
                              currensy: "RUB",
                              debtor: debtors.data![index - 2],
                              update: update,
                              selectedPage: _selectedCard);
                      }
                    },
                  )),
                  Expanded(
                      flex: 3,
                      child: _selectedCard >= 1
                          ? FutureBuilder(
                              future: _selectedCard != 1
                                  ? GetIt.I<SqliteService>().getTransactions(
                                      debtor: debtors.data![_selectedCard - 2])
                                  : GetIt.I<SqliteService>()
                                      .getAllDebtorTransactions(),
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
                                      child: CircularProgressIndicator());
                              })
                          : Container()),
                ],
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        });
  }

  void update(int page) {
    setState(() {
      _selectedCard = page;
    });
  }
}
