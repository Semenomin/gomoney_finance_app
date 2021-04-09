import 'dart:convert';
import 'package:hive/hive.dart';
import 'History.dart';
part 'Debtor.g.dart';

@HiveType(typeId: 7)
class Debtor extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double lendAmount;
  @HiveField(2)
  final double borrowAmount;
  @HiveField(3)
  final History history;
  Debtor({
    required this.id,
    required this.lendAmount,
    required this.borrowAmount,
    required this.history,
  });

  Debtor copyWith({
    String? id,
    double? lendAmount,
    double? borrowAmount,
    History? history,
  }) {
    return Debtor(
      id: id ?? this.id,
      lendAmount: lendAmount ?? this.lendAmount,
      borrowAmount: borrowAmount ?? this.borrowAmount,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lendAmount': lendAmount,
      'borrowAmount': borrowAmount,
      'history': history.toMap(),
    };
  }

  factory Debtor.fromMap(Map<String, dynamic> map) {
    return Debtor(
      id: map['id'],
      lendAmount: map['lendAmount']?.toDouble(),
      borrowAmount: map['borrowAmount']?.toDouble(),
      history: History.fromMap(map['history']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Debtor.fromJson(String source) => Debtor.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Debtor(id: $id, lendAmount: $lendAmount, borrowAmount: $borrowAmount, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Debtor &&
        other.id == id &&
        other.lendAmount == lendAmount &&
        other.borrowAmount == borrowAmount &&
        other.history == history;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lendAmount.hashCode ^
        borrowAmount.hashCode ^
        history.hashCode;
  }
}
