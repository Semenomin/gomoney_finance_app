class Group {
  late final String id;
  late final String name;
  late final double amount;

  Group({required this.id, required this.amount, required this.name});

  Group.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
    this.amount = map["amount"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }
}
