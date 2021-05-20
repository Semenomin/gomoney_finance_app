import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddNameAndAmount.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
import 'package:gomoney_finance_app/util/AppUtils.dart';
import 'package:gomoney_finance_app/util/StyleUtils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gomoney_finance_app/widget/DebtPage/DebtHistoryListTile.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:uuid/uuid.dart';
import '../Enums.dart';
import 'ChooseIconScreen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  CategoryScreen(this.category);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: StyleUtil.primaryColor,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: StyleUtil.primaryColor,
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 60.h,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: double.infinity,
                            width: 60.h,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChooseIconScreen(widget.category)),
                        ).then((value) => setState(() {
                              if (value != null) {
                                widget.category.icon = value;
                              }
                            }));
                      },
                      child: Container(
                        height: 60.r,
                        width: 60.r,
                        child: Icon(widget.category.icon, size: 40.r),
                      )),
                  InkWell(
                    onTap: () {
                      print("dwdw");
                      showDialog<void>(
                          context: context,
                          builder: (_) => Material(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  OColorPicker(
                                    selectedColor: widget.category.color,
                                    colors: primaryColorsPalette,
                                    onColorChange: (color) {
                                      GetIt.I<SqliteService>()
                                          .changeCategoryColor(
                                              widget.category, color);
                                      setState(() {
                                        widget.category.color = color;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )));
                    },
                    child: Container(
                      height: 60.r,
                      width: 60.r,
                      decoration: StyleUtil.rowndedBoxWithShadow
                          .copyWith(color: widget.category.color),
                    ),
                  ),
                  AppUtils.emptyContainer(10.r, 0)
                ],
              ),
              Expanded(
                child: FutureBuilder(
                    future: GetIt.I<SqliteService>()
                        .getTransactions(category: widget.category),
                    builder: (context,
                        AsyncSnapshot<List<FinTransaction>> transactions) {
                      if (transactions.hasData) {
                        return ListView.builder(
                            itemCount: transactions.data!.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return DebtHistoryListTile(
                                  type: transactions
                                          .data![transactions.data!.length -
                                              index -
                                              1]
                                          .isIncome
                                      ? TransactionType.INCOME
                                      : TransactionType.EXPENSE,
                                  name: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .name,
                                  date: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .date,
                                  amount: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .amountOfMoney,
                                  currency: transactions
                                      .data![
                                          transactions.data!.length - index - 1]
                                      .currency);
                            });
                      } else
                        return LoadingPage(StyleUtil.secondaryColor);
                    }),
              ),
              Container(
                height: 70.r,
                child: InkWell(
                  onTap: () {
                    AddNameAndAmount(context, "ADD EXPENSE", update,
                        (nameController, amountController) {
                      GetIt.I<SqliteService>().addTransaction(
                          FinTransaction(
                              isIncome: false,
                              amountOfMoney:
                                  double.parse(amountController.text),
                              name: nameController.text,
                              date: DateTime.now(),
                              id: Uuid().v4(),
                              currency: ""),
                          category: widget.category);
                      Navigator.pop(context);
                    });
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.r),
                    child: Container(
                      decoration: StyleUtil.rowndedBoxWithShadow
                          .copyWith(color: StyleUtil.secondaryColor),
                      child: Center(
                        child: Text("EXPENSE",
                            style: TextStyle(
                                fontSize: 25.r,
                                fontFamily: "Prompt",
                                fontWeight: FontWeight.bold,
                                color: StyleUtil.primaryColor)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  void update(i) {
    setState(() {});
  }
}
