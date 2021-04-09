import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'Debtor.dart';
import 'MoneyBox.dart';
part 'User.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String pushId;
  @HiveField(3)
  final List<MoneyBox> moneyBoxes;
  @HiveField(4)
  final List<Debtor> debtors;
  User({
    required this.id,
    required this.name,
    required this.moneyBoxes,
    required this.debtors,
    required this.pushId,
  });

  User copyWith({
    String? id,
    String? name,
    List<MoneyBox>? moneyBoxs,
    List<Debtor>? debtors,
    String? pushId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      moneyBoxes: moneyBoxs ?? this.moneyBoxes,
      debtors: debtors ?? this.debtors,
      pushId: pushId ?? this.pushId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'moneyBoxes': moneyBoxes.map((x) => x.toMap()).toList(),
      'debtors': debtors.map((x) => x.toMap()).toList(),
      'pushId': pushId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      moneyBoxes: List<MoneyBox>.from(
          map['moneyBoxes']?.map((x) => MoneyBox.fromMap(x))),
      debtors: List<Debtor>.from(map['debtors']?.map((x) => Debtor.fromMap(x))),
      pushId: map['pushId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, moneyBoxs: $moneyBoxes, debtors: $debtors, pushId: $pushId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        listEquals(other.moneyBoxes, moneyBoxes) &&
        listEquals(other.debtors, debtors) &&
        other.pushId == pushId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        moneyBoxes.hashCode ^
        debtors.hashCode ^
        pushId.hashCode;
  }
}
