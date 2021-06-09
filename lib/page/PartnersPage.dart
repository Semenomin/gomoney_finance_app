import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:gomoney_finance_app/model/index.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtCard.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtHistoryListTile.dart';

class PartnersPage extends StatefulWidget {
  @override
  _PartnersPageState createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  PageController _cardController = PageController(initialPage: 1);
  int _selectedCard = 1;
  _PartnersPageState();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<SqliteService>().getAllPartners(),
        builder: (context, AsyncSnapshot<List<Partner>> partners) {
          if (partners.hasData) {
            double allLendAmount = 0;
            double allBorrowAmount = 0;
            for (Partner partner in partners.data!) {
              allLendAmount += partner.lendAmount;
              allBorrowAmount += partner.borrowAmount;
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
                    itemCount: partners.data!.length + 2,
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
                              partner: Partner(
                                  id: "dwdww",
                                  name: "ALL",
                                  lendAmount: allLendAmount,
                                  borrowAmount: allBorrowAmount,
                                  currency: ""),
                              update: update,
                              selectedPage: _selectedCard);
                        default:
                          return DebtCard(
                              currensy: partners.data![index - 2].currency,
                              partner: partners.data![index - 2],
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
                                      partner:
                                          partners.data![_selectedCard - 2])
                                  : GetIt.I<SqliteService>()
                                      .getAllPartnersTransactions(),
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
                                            currency: transactions
                                                .data![
                                                    transactions.data!.length -
                                                        index -
                                                        1]
                                                .currency);
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
