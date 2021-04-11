class Debtor {
  late final String id;
  late String name;
  late double lendAmount;
  late double borrowAmount;
  String? userId;
  String? groupId;
  Debtor(
      {required this.id,
      required this.name,
      required this.lendAmount,
      required this.borrowAmount,
      this.userId,
      this.groupId});

  Debtor.fromMap(Map<String, dynamic?> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.lendAmount = map["lendAmount"];
    this.borrowAmount = map["borrowAmount"];
    this.userId = map["Users_id"];
    this.groupId = map["Group_id"];
  }
}
