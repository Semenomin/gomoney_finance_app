class Planned {
  late final String id;
  late String name;
  late double amountOfMoney;
  late DateTime dateFrom;
  late DateTime dateTo;
  late bool isIncome;
  late String currency;
  String? userId;
  String? groupId;
  Planned(
      {required this.id,
      required this.name,
      required this.amountOfMoney,
      required this.dateFrom,
      required this.dateTo,
      required this.isIncome,
      required this.currency,
      this.userId,
      this.groupId});

  Planned.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.currency = map["currency"];
    this.isIncome = (map["isIncome"] == "true" ? true : false);
    this.amountOfMoney = map["amountOfMoney"];
    this.dateFrom = DateTime.parse(map["dateFrom"]);
    this.dateTo = DateTime.parse(map["dateTo"]);
    this.userId = map["Users_id"];
    this.groupId = map["Group_id"];
  }
}
