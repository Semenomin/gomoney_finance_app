class Scan {
  late final String id;
  late String name;
  late DateTime date;
  late String description;
  late double transactionNum;
  String? path;
  String? userId;
  String? groupId;
  Scan(
      {required this.id,
      required this.name,
      required this.date,
      required this.description,
      required this.transactionNum,
      this.path,
      this.userId,
      this.groupId});

  Scan.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.date = DateTime.parse(map["date"]);
    this.description = map["description"];
    this.transactionNum = map["transactionNum"];
    this.userId = map["Users_id"];
    this.groupId = map["Group_id"];
  }
}
