class FinTransaction {
  late String id;
  late String name;
  late bool isIncome;
  late DateTime date;
  late double amountOfMoney;
  late String currency;
  String? partnerId;
  String? moneyBoxId;
  String? categoryId;
  FinTransaction(
      {required this.id,
      required this.name,
      required this.isIncome,
      required this.date,
      required this.amountOfMoney,
      required this.currency,
      this.partnerId,
      this.moneyBoxId,
      this.categoryId});

  FinTransaction.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.isIncome = map["isIncome"] == "true";
    this.date = DateTime.parse(map["date"]);
    this.amountOfMoney = map["amountOfMoney"];
    this.currency = map["currency"];
    this.partnerId = map["Partner_id"];
    this.moneyBoxId = map["MoneyBox_id"];
    this.categoryId = map["Category_id"];
  }
}
