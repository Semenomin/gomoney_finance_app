class User {
  String id;
  String name;
  String pushId;
  double amountOfMoney;
  User({
    required this.id,
    required this.name,
    required this.pushId,
    this.amountOfMoney = 0.0,
  });
}
