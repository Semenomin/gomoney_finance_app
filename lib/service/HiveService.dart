import 'package:gomoney_finance_app/model/index.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Box<User>? userBox;
  Box<Group>? groupBox;

  Future<HiveService> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(MoneyBoxAdapter());
    Hive.registerAdapter(HistoryAdapter());
    Hive.registerAdapter(GroupAdapter());
    Hive.registerAdapter(DebtorAdapter());

    groupBox = await Hive.openBox('groupBox');
    userBox = await Hive.openBox("userBox");
    return this;
  }

  void clearAll() {
    userBox!.clear();
    groupBox!.clear();
  }
}
