import 'dart:convert';
import 'package:gomoney_finance_app/Enums.dart';
import 'package:hive/hive.dart';
part 'Transaction.g.dart';

@HiveType(typeId: 4)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final TransactionType transactionType;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String date;
  Transaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.date,
  });

  Transaction copyWith({
    String? id,
    TransactionType? transactionType,
    double? amount,
    String? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionType': transactionType,
      'amount': amount,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      transactionType: map['transactionType'],
      amount: map['amount']?.toDouble(),
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(id: $id, transactionType: $transactionType, amount: $amount, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.transactionType == transactionType &&
        other.amount == amount &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        transactionType.hashCode ^
        amount.hashCode ^
        date.hashCode;
  }
}
