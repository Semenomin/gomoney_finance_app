import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'Debtor.dart';
import 'MoneyBox.dart';
import 'User.dart';
part 'Group.g.dart';

@HiveType(typeId: 8)
class Group extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<User> users;
  @HiveField(2)
  final List<Debtor> debtors;
  @HiveField(3)
  final List<MoneyBox> moneyBoxs;
  Group({
    required this.id,
    required this.users,
    required this.debtors,
    required this.moneyBoxs,
  });

  Group copyWith({
    String? id,
    List<User>? users,
    List<Debtor>? debtors,
    List<MoneyBox>? moneyBoxs,
  }) {
    return Group(
      id: id ?? this.id,
      users: users ?? this.users,
      debtors: debtors ?? this.debtors,
      moneyBoxs: moneyBoxs ?? this.moneyBoxs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'users': users.map((x) => x.toMap()).toList(),
      'debtors': debtors.map((x) => x.toMap()).toList(),
      'moneyBoxs': moneyBoxs.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      users: List<User>.from(map['users']?.map((x) => User.fromMap(x))),
      debtors: List<Debtor>.from(map['debtors']?.map((x) => Debtor.fromMap(x))),
      moneyBoxs: List<MoneyBox>.from(
          map['moneyBoxs']?.map((x) => MoneyBox.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, users: $users, debtors: $debtors, moneyBoxs: $moneyBoxs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.id == id &&
        listEquals(other.users, users) &&
        listEquals(other.debtors, debtors) &&
        listEquals(other.moneyBoxs, moneyBoxs);
  }

  @override
  int get hashCode {
    return id.hashCode ^ users.hashCode ^ debtors.hashCode ^ moneyBoxs.hashCode;
  }
}
