class MoneyBox {
  late final String id;
  late String name;
  late double amountOfMoney;
  late double aim;
  late String currency;
  String? userId;
  String? groupId;
  MoneyBox(
      {required this.id,
      required this.name,
      required this.amountOfMoney,
      required this.aim,
      required this.currency,
      this.userId,
      this.groupId});

  MoneyBox.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.amountOfMoney = map["amountOfMoney"];
    this.aim = map["aim"];
    this.currency = map["currency"];
    this.userId = map["Users_id"];
    this.groupId = map["Group_id"];
  }
}
