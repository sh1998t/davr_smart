class DepositReplenishmentsModel {
  final int id;
  final double amount;
  final int status;
  final String statusName;
  final String? comment;
  final String? operatorPhoto;
  final String? courierPhoto;
  final int bankId;
  final String? login;
  final DateTime createdAt;

  DepositReplenishmentsModel(
      {required this.id,
      required this.amount,
      required this.status,
      required this.statusName,
      this.comment,
      this.operatorPhoto,
      this.courierPhoto,
      required this.bankId,
      required this.createdAt,
      required this.login});

  factory DepositReplenishmentsModel.fromJson(Map<String, dynamic> json) {
    return DepositReplenishmentsModel(
        id: json['id'] ?? 0,
        amount: json['amount'] != null
            ? double.tryParse(json['amount'].toString()) ?? 0.0
            : 0.0,
        status: json['status']?['int'] ?? 0,
        statusName: json['status']?['string'] ?? 'Unknown',
        comment: json['comment'],
        operatorPhoto: json['operator_photo'],
        courierPhoto: json['courier_photo'],
        bankId: json['bank_id'] ?? 0,
        createdAt: json['created_at']?['date'] != null
            ? DateTime.parse(json['created_at']['date'])
            : DateTime(1970, 1, 1),
        login: json["user_id"]?['login']);
  }

  static List<DepositReplenishmentsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => DepositReplenishmentsModel.fromJson(json))
        .toList();
  }
}
