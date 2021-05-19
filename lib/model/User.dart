class User {
  late final String id;
  late final String name;
  late final String pushId;
  late double amountOfMoney;
  User({
    required this.id,
    required this.name,
    required this.pushId,
    this.amountOfMoney = 0.0,
  });

  User.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.amountOfMoney = map["amountOfMoney"];
    this.pushId = map["pushId"];
  }
}
