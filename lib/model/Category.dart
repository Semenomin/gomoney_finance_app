import 'package:flutter/material.dart';

class Category {
  late final String id;
  late String name;
  late double amountOfMoney;
  late Color color;
  late String? icon;
  String? userId;
  String? groupId;
  Category(
      {required this.id,
      required this.name,
      required this.amountOfMoney,
      required this.color,
      required this.icon,
      this.userId,
      this.groupId});

  Category.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.amountOfMoney = map["amountOfMoney"];
    this.color = Color(map["color"]);
    this.icon = map["icon"];
    this.userId = map["Users_id"];
    this.groupId = map["Group_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amountOfMoney': amountOfMoney,
      'color': color.value,
      'icon': icon,
      'userId': userId,
      'groupId': groupId,
    };
  }
}
