import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomoney_finance_app/model/Category.dart';
import 'package:gomoney_finance_app/model/MoneyBox.dart';
import 'package:gomoney_finance_app/model/Partner.dart';
import 'package:gomoney_finance_app/model/FinTransaction.dart';
import 'package:gomoney_finance_app/model/Group.dart';
import 'package:gomoney_finance_app/model/Planned.dart';
import 'package:gomoney_finance_app/model/Scan.dart';
import 'package:gomoney_finance_app/model/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'ConnectionService.dart';
import 'PreferencesService.dart';
import 'dart:convert' as convert;
import 'package:encrypt/encrypt.dart' as encrypt;

List<String> tables = [
  "Users",
  "Groups",
  "UserGroups",
  "Category",
  "Partner",
  "Planned",
  "FinTransaction",
  "MoneyBox",
  "Scans",
  "GroupCategories",
  "GroupMoneyBoxes",
  "GroupPartners",
  "GroupCategories"
];

class SqliteService {
  Database? _db;
  String? _databasesPath;
  static const SECRET_KEY = "2020_PRIVATES_KEYS_ENCRYPTS_2020";

  void closeDb() {
    _db!.close();
  }

  Future<SqliteService> init() async {
    _databasesPath = await getDatabasesPath() + "goMoney.db";

    _db = await openDatabase(_databasesPath!, version: 1,
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
            PRIMARY KEY(id));
      """);

      await db.execute(""" CREATE TABLE "UserGroups" (
            id TEXT NOT NULL,
            "Users_id" TEXT NOT NULL,
            "Group_id" TEXT NOT NULL,
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            ,CONSTRAINT "Group-UserGroups"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute(""" CREATE TABLE "GroupMoneyBoxes" (
            id TEXT NOT NULL,
            "Group_id" TEXT NOT NULL,
            "MoneyBox_id" TEXT NOT NULL,
            CONSTRAINT "MoneyBox-GroupMoneyBoxes"
            FOREIGN KEY ("MoneyBox_id")
            REFERENCES "MoneyBox"(id),
            PRIMARY KEY(id));
            CONSTRAINT "Group-GroupMoneyBoxes"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute(""" CREATE TABLE "GroupPartners" (
            id TEXT NOT NULL,
            "Group_id" TEXT NOT NULL,
            "Partner_id" TEXT NOT NULL,
            CONSTRAINT "Partner-GroupPartners"
            FOREIGN KEY ("Partner_id")
            REFERENCES "Partner"(id),
            PRIMARY KEY(id));
            CONSTRAINT "Group-GroupPartners"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute(""" CREATE TABLE "GroupCategories" (
            id TEXT NOT NULL,
            "Group_id" TEXT NOT NULL,
            "Category_id" TEXT NOT NULL,
            CONSTRAINT "Category-GroupCategories"
            FOREIGN KEY ("Category_id")
            REFERENCES "Category"(id),
            PRIMARY KEY(id));
            CONSTRAINT "Group-GroupCategories"
            FOREIGN KEY ("Group_id")
            REFERENCES "Group"(id),
            PRIMARY KEY(id));
      """);

      await db.execute("""CREATE TABLE "Category" (
            id TEXT NOT NULL,
            "Users_id" TEXT,
            amountOfMoney REAL NOT NULL,
            name TEXT NOT NULL,
            icon TEXT NOT NULL,
            color INTEGER NOT NULL,
            CONSTRAINT "Users-Category"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            );
      """);

      await db.execute("""CREATE TABLE "Partner" (
            id TEXT NOT NULL,
            name TEXT,
            "lendAmount" REAL NOT NULL,
            "borrowAmount" REAL NOT NULL,
            "currency" TEXT NOT NULL,
            "Users_id" TEXT,
            CONSTRAINT "Users-Partner"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            );
      """);

      await db.execute("""CREATE TABLE "Scans" (
            id TEXT NOT NULL,
            name TEXT NOT NULL,
            "date" TEXT NOT NULL,
            "transactionNum" REAL,
            "description" TEXT,
            "Users_id" TEXT,
            CONSTRAINT "Users-Partner"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            );
      """);

      await db.execute("""CREATE TABLE "Planned" (
            id TEXT NOT NULL,
            name TEXT,
            amountOfMoney REAL NOT NULL,
            dateFrom TEXT NOT NULL,
            dateTo TEXT NOT NULL,
            isIncome TEXT NOT NULL,
            "currency" TEXT NOT NULL,
            "Users_id" TEXT,
            CONSTRAINT "Users-Planned"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            );
      """);

      await db.execute("""CREATE TABLE "FinTransaction" (
            id TEXT NOT NULL,
            name TEXT,
            isIncome TEXT NOT NULL,
            date TEXT NOT NULL,
            "amountOfMoney" REAL NOT NULL,
            "currency" TEXT NOT NULL,
            "Partner_id" TEXT,
            "MoneyBox_id" TEXT,
            "Category_id" TEXT,CONSTRAINT "MoneyBox-Transaction"
            FOREIGN KEY ("MoneyBox_id")
            REFERENCES "MoneyBox"(id)
            ,CONSTRAINT "Partner-Transaction"
            FOREIGN KEY ("Partner_id")
            REFERENCES "Partner"(id)
            ,CONSTRAINT "Category-Transaction"
            FOREIGN KEY ("Category_id")
            REFERENCES "Category"(id),
            PRIMARY KEY(id));
      """);
      await db.execute("""CREATE TABLE "MoneyBox" (
            id TEXT NOT NULL,
            name TEXT NOT NULL,
            "amountOfMoney" REAL NOT NULL,
            "aim" REAL NOT NULL,
            "currency" TEXT NOT NULL,
            "Users_id" TEXT,
            CONSTRAINT "Users-MoneyBox"
            FOREIGN KEY ("Users_id")
            REFERENCES "Users"(id)
            );
      """);
    });
    return this;
  }

  ///////////////////////////////////////////////////////////////////////////////
  //?                              PLANNED                                   ?//
  //////////////////////////////////////////////////////////////////////////////

  void addPlanned(Planned planned) async {
    await _db!.rawInsert(
        'INSERT INTO Planned(id, Users_id, amountOfMoney, name, isIncome, dateTo, dateFrom, currency) VALUES("${Uuid().v4()}","${GetIt.I<PreferencesService>().getToken()}", ${planned.amountOfMoney} , "${planned.name}", "${planned.isIncome}", "${planned.dateTo}", "${planned.dateFrom}", "${GetIt.I<PreferencesService>().getCurrency()}")');
  }

  Future<List<Planned>> getAllPlanned({token}) async {
    var res = await _db!.rawQuery(
        'Select * from Planned where Users_id = "${token != null ? token : GetIt.I<PreferencesService>().getToken()}"');
    return List.generate(res.length, (index) => Planned.fromMap(res[index]));
  }

  Future<void> updatePlanned(Planned planned) async {
    await _db!.rawUpdate(
        "UPDATE Planned set dateFrom = ${planned.dateFrom}, dateTo = ${planned.dateTo} where id = '${planned.id}'");
  }

  Future<void> changePlannedName(Planned planned) async {
    await _db!.rawUpdate(
        "UPDATE Planned set name = '${planned.name}' where id = '${planned.id}'");
  }

  Future<void> changePlannedAmountOfMoney(Planned planned) async {
    await _db!.rawUpdate(
        "UPDATE Planned set amountOfMoney = ${planned.amountOfMoney} where id = '${planned.id}'");
  }

  Future<void> changePlannedIsIncome(Planned planned) async {
    await _db!.rawUpdate(
        "UPDATE Planned set isIncome = '${planned.isIncome}' where id = '${planned.id}'");
  }

  void deletePlanned(Planned planned) async {
    await _db!.rawDelete("delete from Planned where id = '${planned.id}'");
  }
  //////////////////////////////////////////////////////////////////////////////
  //?                              CATEGORY                                  ?//
  //////////////////////////////////////////////////////////////////////////////

  void addCategory(Category category) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Category(id, Users_id, amountOfMoney, name, icon, color) VALUES("${category.id}","${category.userId}", ${category.amountOfMoney}, "${category.name}", "${category.icon}", "${category.color.value}")');
    });
  }

  Future<List<Category>> getUserCategorys() async {
    var res = await _db!.rawQuery('Select * from Category');
    return List.generate(res.length, (index) => Category.fromMap(res[index]));
  }

  Future<List<Category>> getCategoriesByIds(List<String> ids) async {
    var res1 = '';
    for (var item in ids) {
      if (item == ids[ids.length - 1]) {
        res1 += '\"' + item + '\"';
      } else {
        res1 += '\"' + item + '\",';
      }
    }
    var res = await _db!.rawQuery('Select * from Category where id in ($res1)');
    return List.generate(res.length, (index) => Category.fromMap(res[index]));
  }

  void changeCategoryIcon(Category category, String icon) async {
    await _db!.rawUpdate(
        "UPDATE Category set icon = '$icon' where id = '${category.id}'");
  }

  void changeCategoryColor(Category category, Color color) async {
    await _db!.rawUpdate(
        "UPDATE Category set color = '${color.value}' where id = '${category.id}'");
  }

  void changeCategoryName(Category category) async {
    await _db!.rawUpdate(
        "UPDATE Category set name = '${category.name}' where id = '${category.id}'");
  }

  void deleteCategory(Category category) async {
    await _db!.rawDelete("delete from Category where id = '${category.id}'");
  }

  //////////////////////////////////////////////////////////////////////////////
  //?                              MONEYBOX                                  ?//
  //////////////////////////////////////////////////////////////////////////////

  Future<List<MoneyBox>> getUserMoneyBoxes() async {
    var res = await _db!.rawQuery(
        'Select * from MoneyBox where Users_id = "${GetIt.I<PreferencesService>().getToken()}"');
    return List.generate(res.length, (index) => MoneyBox.fromMap(res[index]));
  }

  Future<List<MoneyBox>> getAllMoneyBoxes() async {
    var res = await _db!.rawQuery('Select * from MoneyBox');
    return List.generate(res.length, (index) => MoneyBox.fromMap(res[index]));
  }

  Future<List<MoneyBox>> getMoneyBoxesByIds(List<String> ids) async {
    var res1 = '';
    for (var item in ids) {
      if (item == ids[ids.length - 1]) {
        res1 += '\"' + item + '\"';
      } else {
        res1 += '\"' + item + '\",';
      }
    }
    var res = await _db!.rawQuery('Select * from MoneyBox where id in ($res1)');
    return List.generate(res.length, (index) => MoneyBox.fromMap(res[index]));
  }

  void addMoneyBox(MoneyBox moneyBox) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO MoneyBox(id, Users_id, amountOfMoney, name, aim, currency) VALUES("${moneyBox.id}","${moneyBox.userId}", ${moneyBox.amountOfMoney}, "${moneyBox.name}", ${moneyBox.aim},"${moneyBox.currency}")');
    });
  }

  void deleteMoneyBox(MoneyBox moneyBox) async {
    await _db!.rawInsert(
        'INSERT INTO FinTransaction(id, name, isIncome, date, amountOfMoney, Partner_id, MoneyBox_id, Category_id, currency) VALUES("${Uuid().v4()}", "Break Box ${moneyBox.name}", "true", "${DateTime.now()}", ${moneyBox.amountOfMoney}, null, "${moneyBox.id}", null, "${moneyBox.currency}")');
    await _db!.rawUpdate(
        "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${moneyBox.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
    await _db!.rawDelete("delete from MoneyBox where id = '${moneyBox.id}'");
  }

  //////////////////////////////////////////////////////////////////////////////
  //?                                USER                                    ?//
  //////////////////////////////////////////////////////////////////////////////

  void addUser(User user) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT OR IGNORE INTO Users(id, name, amountOfMoney, pushId) VALUES("${user.id}", "${user.name}", ${user.amountOfMoney}, "${user.pushId}")');
    });
  }

  Future<User> getUser() async {
    var res = await _db!.rawQuery('Select * from Users');
    if (res.length == 0) {
      return User(id: Uuid().v4(), pushId: "", name: "");
    }
    return User.fromMap(res.first);
  }

  Future<Group?> getGroupByMoneyBoxId(String id) async {
    var q =
        'Select Groups.id, Groups.name from GroupMoneyBoxes inner join Groups on GroupMoneyBoxes.Group_id = Groups.id where GroupMoneyBoxes.MoneyBox_id = "$id"';
    var res = await _db!.rawQuery(q);
    if (res.isEmpty) return null;
    return Group.fromMap(res.first);
  }

  Future<Group?> getGroupByPartnerId(String id) async {
    var q =
        'Select Groups.id, Groups.name from GroupPartners inner join Groups on GroupPartners.Group_id = Groups.id where GroupPartners.Partner_id = "$id"';
    var res = await _db!.rawQuery(q);
    if (res.isEmpty) return null;
    return Group.fromMap(res.first);
  }

  Future<Group?> getGroupByCategoryId(String id) async {
    var q =
        'Select Groups.id, Groups.name from GroupCategories inner join Groups on GroupCategories.Group_id = Groups.id where GroupCategories.Category_id = "$id"';
    var res = await _db!.rawQuery(q);
    if (res.isEmpty) return null;
    return Group.fromMap(res.first);
  }

  Future<List<User>> getGroupUsers(Group group) async {
    var q =
        'Select Users.id , Users.name, Users.amountOfMoney, Users.pushId from UserGroups inner join Users on UserGroups.Users_id = Users.id where UserGroups.Group_id = "${group.id}"';
    var res = await _db!.rawQuery(q);
    return List.generate(res.length, (index) => User.fromMap(res[index]));
  }

  Future<List<String>> getGroupPushes(Group group) async {
    var q =
        'Select Users.pushId from UserGroups inner join Users on UserGroups.Users_id = Users.id where UserGroups.Group_id = "${group.id}"';
    var res = await _db!.rawQuery(q);
    return List.generate(res.length, (index) => res[index]["pushId"] as String);
  }

  Future<List<String>> getGroupMoneyBoxes(String groupId) async {
    var q =
        'Select MoneyBox.id from GroupMoneyBoxes inner join MoneyBox on GroupMoneyBoxes.MoneyBox_id = MoneyBox.id where GroupMoneyBoxes.Group_id = "$groupId"';
    var res = await _db!.rawQuery(q);
    List<String> list = [];
    for (var item in res) {
      list.add(item["id"].toString());
    }
    return list;
  }

  Future<List<String>> getGroupPartners(String groupId) async {
    var q =
        'Select Partner.id from GroupPartners inner join Partner on GroupPartners.Partner_id = Partner.id where GroupPartners.Group_id = "$groupId"';
    var res = await _db!.rawQuery(q);
    List<String> list = [];
    for (var item in res) {
      list.add(item["id"].toString());
    }
    return list;
  }

  Future<List<String>> getGroupCategories(String groupId) async {
    var q =
        'Select Category.id from GroupCategories inner join Category on GroupCategories.Category_id = Category.id where GroupCategories.Group_id = "$groupId"';
    var res = await _db!.rawQuery(q);
    List<String> list = [];
    for (var item in res) {
      list.add(item["id"].toString());
    }
    return list;
  }

  void addGroupMoneyBoxes(MoneyBox moneyBox, String groupId) async {
    await _db!.rawInsert(
        'INSERT INTO GroupMoneyBoxes (id, MoneyBox_id, Group_id) VALUES("${Uuid().v4()}", "${moneyBox.id}", "$groupId")');
  }

  void addGroupPartners(Partner partner, String groupId) async {
    await _db!.rawInsert(
        'INSERT INTO GroupPartners (id, Partner_id, Group_id) VALUES("${Uuid().v4()}", "${partner.id}", "$groupId")');
  }

  void addGroupCategories(Category category, String groupId) async {
    await _db!.rawInsert(
        'INSERT INTO GroupCategories (id, Category_id, Group_id) VALUES("${Uuid().v4()}", "${category.id}", "$groupId")');
  }

  void addGroup(Group group) async {
    await _db!
        .rawInsert(
            'INSERT INTO Groups (id, name, amount) VALUES("${group.id}", "${group.name}", ${group.amount})')
        .then((value) async {
      await _db!.rawInsert(
          'INSERT INTO UserGroups (id, Users_id, Group_id) VALUES("${Uuid().v4()}", "${GetIt.I<PreferencesService>().getToken()}", "${group.id}")');
    });
  }

  void addGroupUsers(Group group, List<User> users) async {
    for (var user in users) {
      await _db!.rawInsert(
          'INSERT INTO UserGroups (id, Users_id, Group_id) VALUES("${Uuid().v4()}", "${user.id}", "${group.id}")');
    }
  }

  void addPartner(Partner partner) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Partner(id, name, lendAmount, borrowAmount, Users_id,  currency) VALUES("${partner.id}", "${partner.name}", ${partner.lendAmount}, ${partner.borrowAmount}, "${partner.userId}", "${GetIt.I<PreferencesService>().getCurrency()}")');
    });
  }

  Future<List<Partner>> getPartnersByIds(List<String> ids) async {
    var res1 = '';
    for (var item in ids) {
      if (item == ids[ids.length - 1]) {
        res1 += '\"' + item + '\"';
      } else {
        res1 += '\"' + item + '\",';
      }
    }
    var res = await _db!.rawQuery('Select * from Partner where id in ($res1)');
    return List.generate(res.length, (index) => Partner.fromMap(res[index]));
  }

  void addTransaction(FinTransaction transaction,
      {Partner? partner,
      Category? category,
      MoneyBox? moneyBox,
      bool? isPush}) async {
    Group? group;
    String? partnerId;
    String? moneyBoxId;
    String? categoryId;
    String? currency;
    if (partner != null) partnerId = "\"" + partner.id + "\"";
    if (category != null) categoryId = "\"" + category.id + "\"";
    if (moneyBox != null) moneyBoxId = "\"" + moneyBox.id + "\"";

    if (transaction.partnerId != null) {
      group = await GetIt.I<SqliteService>().getGroupByPartnerId(partner!.id);
      currency = partner.currency;
      if (!transaction.isIncome) {
        double lendAmount = partner.lendAmount;
        double borrowAmount = partner.borrowAmount;
        borrowAmount = borrowAmount - transaction.amountOfMoney;
        if (borrowAmount < 0) {
          lendAmount += -borrowAmount;
          borrowAmount = 0;
        } else {
          lendAmount = 0;
        }
        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

        await _db!.rawUpdate(
            "UPDATE Partner set lendAmount = $lendAmount, borrowAmount = $borrowAmount where id = $partnerId");
      } else {
        double lendAmount = partner.lendAmount;
        double borrowAmount = partner.borrowAmount;
        lendAmount = lendAmount - transaction.amountOfMoney;
        if (lendAmount < 0) {
          borrowAmount += -lendAmount;
          lendAmount = 0;
        } else {
          borrowAmount = 0;
        }

        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
        await _db!.rawUpdate(
            "UPDATE Partner set lendAmount = $lendAmount, borrowAmount = $borrowAmount where id = $partnerId");
      }
    } else if (categoryId != null) {
      group = await GetIt.I<SqliteService>().getGroupByCategoryId(category!.id);
      if (transaction.isIncome) {
        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

        await _db!.rawUpdate(
            "UPDATE Category set amountOfMoney = (select amountOfMoney from Category where id = $categoryId) + ${transaction.amountOfMoney} where id = $categoryId");
      } else {
        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");

        await _db!.rawUpdate(
            "UPDATE Category set amountOfMoney = (select amountOfMoney from Category where id = $categoryId) - ${transaction.amountOfMoney} where id = $categoryId");
      }
    } else if (moneyBoxId != null) {
      group = await GetIt.I<SqliteService>().getGroupByMoneyBoxId(moneyBox!.id);
      currency = moneyBox.currency;
      await _db!.rawUpdate(
          "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
      await _db!.rawUpdate(
          "UPDATE MoneyBox set amountOfMoney = (select amountOfMoney from MoneyBox where id = '${moneyBox.id}') + ${transaction.amountOfMoney} where id = '${moneyBox.id}'");
    } else {
      if (transaction.isIncome) {
        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') + ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
      } else {
        await _db!.rawUpdate(
            "UPDATE Users set amountOfMoney = (select amountOfMoney from Users where id = '${GetIt.I<PreferencesService>().getToken()}') - ${transaction.amountOfMoney} where id = '${GetIt.I<PreferencesService>().getToken()}'");
      }
    }
    if (isPush == null) {
      if (group != null) {
        GetIt.I<ConnectionService>().sendOperation(group, transaction);
      }
    }
    await _db!.rawInsert(
        'INSERT INTO FinTransaction(id, name, isIncome, date, amountOfMoney, Partner_id, MoneyBox_id, Category_id, currency) VALUES("${transaction.id}", "${transaction.name}", "${transaction.isIncome}", "${transaction.date}", ${transaction.amountOfMoney}, $partnerId, $moneyBoxId, $categoryId, "${currency == null ? GetIt.I<PreferencesService>().getCurrency() : currency}")');
  }

  Future<List<FinTransaction>> getTransactions(
      {Partner? partner, Category? category, MoneyBox? moneyBox}) async {
    if (partner != null) {
      var res = await _db!.rawQuery(
          'select FinTransaction.id, Partner.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.partner_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id, FinTransaction.currency from FinTransaction inner JOIN Partner on Partner.id = FinTransaction.Partner_id where Partner.id = "${partner.id}"');
      return List.generate(
          res.length, (index) => FinTransaction.fromMap(res[index]));
    } else if (category != null) {
      var res = await _db!.rawQuery(
          'select FinTransaction.id, FinTransaction.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.partner_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id, FinTransaction.currency from FinTransaction inner JOIN Category on Category.id = FinTransaction.Category_id where Category.id = "${category.id}"');
      return List.generate(
          res.length, (index) => FinTransaction.fromMap(res[index]));
    } else if (moneyBox != null) {
      var res = await _db!.rawQuery(
          'select FinTransaction.id, FinTransaction.name, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.partner_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id, FinTransaction.currency from FinTransaction inner JOIN MoneyBox on MoneyBox.id = FinTransaction.MoneyBox_id where MoneyBox.id = "${moneyBox.id}"');
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

  Future<List<FinTransaction>> getAllPartnersTransactions() async {
    var res = await _db!.rawQuery(
        'select FinTransaction.id, Partner.name, FinTransaction.currency, FinTransaction.isIncome, FinTransaction.date, FinTransaction.amountOfMoney, FinTransaction.Partner_id, FinTransaction.MoneyBox_id, FinTransaction.Category_id from FinTransaction inner JOIN Partner on Partner.id = FinTransaction.Partner_id');
    print(res);
    return List.generate(
        res.length, (index) => FinTransaction.fromMap(res[index]));
  }

  Future<List<Partner>> getAllPartners() async {
    var res = await _db!.rawQuery(
        'Select Partner.id, Partner.name, Partner.lendAmount, Partner.borrowAmount,Partner.currency, Users.name as Users_id from Partner left outer join Users on Users.id = Partner.Users_id');
    return List.generate(res.length, (index) => Partner.fromMap(res[index]));
  }

  void deletePartner(Partner partner) async {
    await _db!.rawDelete("delete from Partner where id = '${partner.id}'");
  }

  Future<List<Group>> getGroups() async {
    var res = await _db!.rawQuery('Select * from Groups');
    return List.generate(res.length, (index) => Group.fromMap(res[index]));
  }

  Future<List<Scan>> getScans() async {
    var res = await _db!.rawQuery(
        'Select * from Scans where Users_id = "${GetIt.I<PreferencesService>().getToken()}"');
    return List.generate(res.length, (index) => Scan.fromMap(res[index]));
  }

  Future<Scan> getScanById(String id) async {
    var res = await _db!.rawQuery('Select * from Scans where id = "$id"');
    return Scan.fromMap(res[0]);
  }

  Future<void> addScan(Scan scan) async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Scans(id, name, date, description, transactionNum, Users_id) VALUES("${scan.id}", "${scan.name}", "${scan.date.toString()}" , "${scan.description.replaceAll("\"", "\'")}",${scan.transactionNum}, "${GetIt.I<PreferencesService>().getToken()}")');
    });
  }

  Future<void> updateDescription(String desc, String id) async {
    await _db!.transaction((txn) async {
      await txn
          .rawUpdate('Update Scans set description = "$desc" where id = "$id"');
    });
  }

  void deleteDB() async {
    deleteDatabase(_databasesPath!);
  }

  Future clearAllTables() async {
    try {
      for (String table in tables) {
        await _db!.delete(table);
        print('------ DELETE $table');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> generateBackup({bool isEncrypted = true}) async {
    print('GENERATE BACKUP');
    var dbs = _db;
    List data = [];
    List<Map<String, dynamic>> listMaps = [];
    for (var i = 0; i < tables.length; i++) {
      listMaps = await dbs!.query(tables[i]);
      data.add(listMaps);
    }
    List backups = [tables, data];
    String json = convert.jsonEncode(backups);
    if (isEncrypted) {
      final key = encrypt.Key.fromUtf8(SECRET_KEY);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(json, iv: iv);
      print("BACKUP GENERATED");
      return encrypted.base64;
    } else {
      return json;
    }
  }

  Future<void> restoreBackup(String backup, {bool isEncrypted = true}) async {
    var dbs = _db;
    Batch batch = dbs!.batch();
    final key = encrypt.Key.fromUtf8(SECRET_KEY);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    List json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);
    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        batch.insert(json[0][i], json[1][i][k]);
      }
    }
    await batch.commit(continueOnError: false, noResult: true);
    print('RESTORE BACKUP');
  }
}
