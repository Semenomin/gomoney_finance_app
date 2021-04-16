import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/dialogs/AddNameAndAmount.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/page/LoadingPage.dart';
import 'package:gomoney_finance_app/service/SqliteService.dart';
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
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: StyleUtil.rowndedBoxWithShadow.copyWith(
                          color: widget.category.color,
                          borderRadius: BorderRadius.circular(100)),
                      height: 60.h,
                      width: 115.h,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseIconScreen(widget.category)),
                                ).then((value) => setState(() {
                                      widget.category.icon = value;
                                    }));
                              },
                              child: Container(
                                width: 50.r,
                                height: 60.r,
                                child: Icon(widget.category.icon, size: 35.r),
                              )),
                          VerticalDivider(
                            color: Colors.black,
                          ),
                          InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          OColorPicker(
                                            selectedColor:
                                                widget.category.color,
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
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 50.h,
                                height: 60.h,
                              ))
                        ],
                      ),
                    ),
                  ),
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
                                  currency: "RUB");
                            });
                      } else
                        return LoadingPage(StyleUtil.secondaryColor);
                    }),
              ),
              Container(
                height: 70.r,
                color: StyleUtil.secondaryColor,
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        AddNameAndAmount(context, "ADD INCOME", update,
                            (nameController, amountController) {
                          GetIt.I<SqliteService>().addTransaction(
                              FinTransaction(
                                  isIncome: true,
                                  amountOfMoney:
                                      double.parse(amountController.text),
                                  name: nameController.text,
                                  date: DateTime.now(),
                                  id: Uuid().v4()),
                              category: widget.category);
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        child: Center(
                          child: Text("INCOME",
                              style: TextStyle(
                                  fontSize: 20.w,
                                  fontFamily: "Prompt",
                                  fontWeight: FontWeight.bold,
                                  color: StyleUtil.primaryColor)),
                        ),
                      ),
                    )),
                    VerticalDivider(
                      thickness: 3,
                      color: StyleUtil.primaryColor,
                    ),
                    Expanded(
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
                                  id: Uuid().v4()),
                              category: widget.category);
                          Navigator.pop(context);
                        });
                        setState(() {});
                      },
                      child: Container(
                        child: Center(
                          child: Text("EXPENSE",
                              style: TextStyle(
                                  fontSize: 20.w,
                                  fontFamily: "Prompt",
                                  fontWeight: FontWeight.bold,
                                  color: StyleUtil.primaryColor)),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  void update() {
    setState(() {});
  }
}
