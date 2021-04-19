import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/Debtor.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'PreferencesService.dart';

class SqliteService {
  Database? _db;
  String? _databasesPath;

  void closeDb() {
    _db!.close();
  }

  Future<SqliteService> init() async {
    _databasesPath =
        await getApplicationDocumentsDirectory().then((value) => value.path);

    String path = join(_databasesPath! + "/database", "dbGoMoney");

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE 'Users' (
            id TEXT NOT NULL,
            name TEXT,
            "pushId" TEXT NOT NULL,
            "amountOfMoney" REAL NOT NULL,
            PRIMARY KEY(id));
      """);

      await db.execute("""CREATE TABLE "Groups" (
            id TEXT NOT NULL,
            name TEXT,
            amount REAL NOT NULL,
            PRIMARY KEY(id));
      """);

      await db.execute(""" CREATE TABLE "UserGroups" (
            id INTEGER NOT NULL,
            "Users_id" TEXT NOT NULL,
            "Group_id" TEXT NOT NULL,
            "amountPercent" INTEGER,CONSTRAINT "Users-UserGroups"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            ,CONSTRAINT "Group-UserGroups"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute("""CREATE TABLE "Category" (
            id TEXT NOT NULL,
            "Users_id" TEXT,
            "Group_id" TEXT,
            amountOfMoney REAL NOT NULL,
            name TEXT NOT NULL,
            icon TEXT NOT NULL,
            color INTEGER NOT NULL,CONSTRAINT "Users-Category"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            ,CONSTRAINT "Group-Category"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute("""CREATE TABLE "Debtor" (
            id TEXT NOT NULL,
            name TEXT,
            "lendAmount" REAL NOT NULL,
            "borrowAmount" REAL NOT NULL,
            "Users_id" TEXT,
            "Group_id" TEXT,CONSTRAINT "Users-Debtor"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            ,CONSTRAINT "Group-Debtor"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute("""CREATE TABLE "FinTransaction" (
            id TEXT NOT NULL,
            name TEXT,
            isIncome TEXT NOT NULL,
            date TEXT NOT NULL,
            "amountOfMoney" REAL NOT NULL,
            "Debtor_id" TEXT,
            "MoneyBox_id" TEXT,
            "Category_id" TEXT,CONSTRAINT "MoneyBox-Transaction"
            FOREIGN KEY ("MoneyBox_id")
            REFERENCES "MoneyBox"(id)
            ,CONSTRAINT "Debtor-Transaction"
            FOREIGN KEY ("Debtor_id")
            REFERENCES "Debtor"(id)
            ,CONSTRAINT "Category-Transaction"
            FOREIGN KEY ("Category_id")
            REFERENCES "Category"(id),
            PRIMARY KEY(id));
      """);
      await db.execute("""CREATE TABLE "MoneyBox" (
            id TEXT NOT NULL,
            name TEXT NOT NULL,
            "amountOfMoney" REAL NOT NULL,
            "Users_id" TEXT,
            "Group_id" TEXT,CONSTRAINT "Users-MoneyBox"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            ,CONSTRAINT "Group-MoneyBox"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);
    });
    return this;
  }

  Future<List<Category>> getUserCategorys() async {
    var res = await _db!.rawQuery(
        'Select * from Category where Users_id = "${GetIt.I<PreferencesService>().getToken()}"');
    return List.generate(res.length, (index) => Category.fromMap(res[index]));
  }

  void changeCategoryColor(Category category, Color color) async {
    await _db!.rawUpdate(
        "UPDATE Category set color = '${color.value}' where id = '${category.id}'");
  }

  void changeCategoryIcon(Category category, String icon) async {
    await _db!.rawUpdate(
        "UPDATE Category set icon = '$icon' where id = '${category.id}'");
  }

  void addCategory(String name) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Category(id, Users_id, Group_id,amountOfMoney, name, icon, color) VALUES("${Uuid().v4()}","${GetIt.I<PreferencesService>().getToken()}", null, 0.0, "$name", "ban", "${Colors.white.value}")');
    });
  }

  void addUser(User user) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Users(id, name, amountOfMoney, pushId) VALUES("${user.id}", "${user.name}", ${user.amountOfMoney}, "${user.pushId}")');
    });
  }

  void addDebtor(Debtor debtor) async {
    if (debtor.groupId != null)
      debtor.groupId = "\"" + debtor.groupId! + "\"";
    else
      debtor.userId = "\"" + debtor.userId! + "\"";
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Debtor(id, name, lendAmount, borrowAmount, Users_id, Group_id) VALUES("${debtor.id}", "${debtor.name}", ${debtor.lendAmount}, ${debtor.borrowAmount}, ${debtor.userId}, ${debtor.groupId})');
    });
  }

  void addTransaction(FinTransaction transaction,
      {Debtor? debtor, Category? category}) async {
    String? debtorId;
    String? moneyBoxId;
    String? categoryId;
    if (debtor != null) debtorId = "\"" + debtor.id + "\"";
    if (category != null) categoryId = "\"" + category.id + "\"";

    await _db!.transaction((txn) async {
      if (transaction.debtorId != null) {
        if (!transaction.isIncome) {
          double lendAmount = debtor!.lendAmount;
          double borrowAmount = debtor.borrowAmount;
          borrowAmount = borrowAmount - transaction.amountOfMoney;
          if (borrowAmount < 0) {
            lendAmount += -borrowAmount;
            borrowAmount = 0;
          } else {
            lendAmount = 0;
          }
          await txn.rawUpdate(
              "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

          await txn.rawUpdate(
              "UPDATE Debtor set lendAmount = $lendAmount, borrowAmount = $borrowAmount where id = $debtorId");
        } else {
          double lendAmount = debtor!.lendAmount;
          double borrowAmount = debtor.borrowAmount;
          lendAmount = lendAmount - transaction.amountOfMoney;
          if (lendAmount < 0) {
            borrowAmount += -lendAmount;
            lendAmount = 0;
          } else {
            borrowAmount = 0;
          }

          await txn.rawUpdate(
              "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
          await txn.rawUpdate(
              "UPDATE Debtor set lendAmount = $lendAmount, borrowAmount = $borrowAmount where id = $debtorId");
        }
      } else if (categoryId != null) {
        if (transaction.isIncome) {
          await txn.rawUpdate(
              "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

          await txn.rawUpdate(
              "UPDATE Category set amountOfMoney = (select amountOfMoney from Category where id = $categoryId) + ${transaction.amountOfMoney} where id = $categoryId");
        } else {
          await txn.rawUpdate(
              "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

          await txn.rawUpdate(
              "UPDATE Category set amountOfMoney = (select amountOfMoney from Category where id = $categoryId) - ${transaction.amountOfMoney} where id = $categoryId");
        }
      }
      await txn.rawInsert(
          'INSERT INTO FinTransaction(id, name, isIncome, date, amountOfMoney, Debtor_id, MoneyBox_id, Category_id) VALUES("${transaction.id}", "${transaction.name}", "${transaction.isIncome}", "${transaction.date}", ${transaction.amountOfMoney}, $debtorId, $moneyBoxId, $categoryId)');
    });
  }

  Future<List<FinTransaction>> getTransactions(
      {Debtor? debtor, Category? category}) async {
    if (debtor != null) {
      var res = await _db!.rawQuery(
          'select FinTransaction.id, Debtor.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.debtor_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id from FinTransaction inner JOIN Debtor on Debtor.id = FinTransaction.Debtor_id where Debtor.id = "${debtor.id}"');
      return List.generate(
          res.length, (index) => FinTransaction.fromMap(res[index]));
    } else if (category != null) {
      var res = await _db!.rawQuery(
          'select FinTransaction.id, FinTransaction.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.debtor_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id from FinTransaction inner JOIN Category on Category.id = FinTransaction.Category_id where Category.id = "${category.id}"');
      return List.generate(
          res.length, (index) => FinTransaction.fromMap(res[index]));
    } else
      return List.empty();
  }

  Future<List<FinTransaction>> getTransactionsByDate(DateTime date) async {
    var res = await _db!.rawQuery(
        'SELECT * FROM FinTransaction where substr(date, 0, 11) = substr("${date.toString()}", 0, 11)');
    return List.generate(
        res.length, (index) => FinTransaction.fromMap(res[index]));
  }

  Future<List<FinTransaction>> getAllDebtorTransactions() async {
    var res = await _db!.rawQuery(
        'select FinTransaction.id, Debtor.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.debtor_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id from FinTransaction inner JOIN Debtor on Debtor.id = FinTransaction.Debtor_id');
    return List.generate(
        res.length, (index) => FinTransaction.fromMap(res[index]));
  }

  Future<List<Debtor>> getAllDebtors() async {
    var res = await _db!.rawQuery(
        'Select Debtor.id, Debtor.name, Debtor.lendAmount, Debtor.borrowAmount, Users.name as Users_id, Groups.name As Group_id from Debtor left outer join Users on Users.id = Debtor.Users_id left outer join Groups on Groups.id = Debtor.group_id ');
    return List.generate(res.length, (index) => Debtor.fromMap(res[index]));
  }

  void deleteDebtor(Debtor debtor) async {
    await _db!.rawDelete("delete from Debtor where id = '${debtor.id}'");
  }

  Future<User> getUser() async {
    var res = await _db!.rawQuery(
        'Select * from Users where id = "${GetIt.I<PreferencesService>().getToken()}" ');
    return User.fromMap(res.first);
  }

  Future<List<Group>> getGroups() async {
    var res = await _db!.rawQuery('Select * from Groups');
    return List.generate(res.length, (index) => Group.fromMap(res[index]));
  }

  void deleteDB() async {
    deleteDatabase(_databasesPath!);
  }
}
