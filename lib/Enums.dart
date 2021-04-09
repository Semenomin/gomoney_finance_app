import 'package:hive/hive.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  EXPENSE,
  @HiveField(1)
  INCOME
}

@HiveType(typeId: 1)
enum ChartType {
  @HiveField(0)
  CIRCLE,
  @HiveField(1)
  LINEAR,
  @HiveField(2)
  BAR
}

@HiveType(typeId: 2)
enum HistoryType {
  @HiveField(0)
  DEBT,
  @HiveField(1)
  MONEYBOX,
  @HiveField(2)
  USER,
  @HiveField(3)
  GROUP
}
