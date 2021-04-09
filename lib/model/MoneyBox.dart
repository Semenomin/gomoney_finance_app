import 'dart:convert';
import 'package:hive/hive.dart';
import 'History.dart';
part 'MoneyBox.g.dart';

@HiveType(typeId: 5)
class MoneyBox extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final History history;
  MoneyBox({
    required this.id,
    required this.amount,
    required this.history,
  });

  MoneyBox copyWith({
    String? id,
    double? amount,
    History? history,
  }) {
    return MoneyBox(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'history': history.toMap(),
    };
  }

  factory MoneyBox.fromMap(Map<String, dynamic> map) {
    return MoneyBox(
      id: map['id'],
      amount: map['amount']?.toDouble(),
      history: History.fromMap(map['history']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MoneyBox.fromJson(String source) =>
      MoneyBox.fromMap(json.decode(source));

  @override
  String toString() => 'MoneyBox(id: $id, amount: $amount, history: $history)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoneyBox &&
        other.id == id &&
        other.amount == amount &&
        other.history == history;
  }

  @override
  int get hashCode => id.hashCode ^ amount.hashCode ^ history.hashCode;
}
