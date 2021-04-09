import 'dart:convert';
import 'package:hive/hive.dart';
import '../Enums.dart';
import 'Transaction.dart';
part 'History.g.dart';

@HiveType(typeId: 6)
class History extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final HistoryType historyType;
  @HiveField(2)
  final List<Transaction> transactions;
  History({
    required this.id,
    required this.historyType,
    required this.transactions,
  });

  History copyWith({
    String? id,
    HistoryType? historyType,
    List<Transaction>? transactions,
  }) {
    return History(
      id: id ?? this.id,
      historyType: historyType ?? this.historyType,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'historyType': historyType,
      'transactions': transactions.map((x) => x.toMap()).toList(),
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      id: map['id'],
      historyType: map['historyType'],
      transactions: List<Transaction>.from(
          map['transactions']?.map((x) => Transaction.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory History.fromJson(String source) =>
      History.fromMap(json.decode(source));

  @override
  String toString() =>
      'History(id: $id, historyType: $historyType, transactions: $transactions)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is History &&
        other.id == id &&
        other.historyType == historyType &&
        other.transactions == transactions;
  }

  @override
  int get hashCode =>
      id.hashCode ^ historyType.hashCode ^ transactions.hashCode;
}
