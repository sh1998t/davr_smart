class BankModel {
  final int id;
  final String name;
  final String url;
  BankModel({
    required this.id,
    required this.name,
    required this.url,
  });
  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(id: json['id'], name: json['name'], url: json['logo']);
  }
}
