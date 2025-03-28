import 'dart:convert';

class CourierData {
  final int courierId;
  final String courierFullName;
  final String courierUserName;
  final String courierRegionName;
  final String courierStructureName;
  final int totalAcceptedCount;
  final int totalAcceptedAmount;
  final int totalWaitingCount;
  final int totalWaitingAmount;
  final int totalConfirmedCount;
  final int totalConfirmedAmount;
  final String fromDateTime;
  final String toDateTime;
  final int courierBalance;
  final String courierLastDepositDate;
  final String? courierCode;

  CourierData(
      {required this.courierId,
      required this.courierFullName,
      required this.courierUserName,
      required this.courierRegionName,
      required this.courierStructureName,
      required this.totalAcceptedCount,
      required this.totalAcceptedAmount,
      required this.totalWaitingCount,
      required this.totalWaitingAmount,
      required this.totalConfirmedCount,
      required this.totalConfirmedAmount,
      required this.fromDateTime,
      required this.toDateTime,
      required this.courierBalance,
      required this.courierLastDepositDate,
      required this.courierCode});

  // JSON dan modelga o'tkazish
  factory CourierData.fromJson(Map<String, dynamic> json) {
    return CourierData(
        courierId: json["courierId"],
        courierFullName: json["courierFullName"],
        courierUserName: json["courierUserName"],
        courierRegionName: json["courierRegionName"],
        courierStructureName: json["courierStructureName"],
        totalAcceptedCount: json["totalAcceptedCount"],
        totalAcceptedAmount: json["totalAcceptedAmount"],
        totalWaitingCount: json["totalWaitingCount"],
        totalWaitingAmount: json["totalWaitingAmount"],
        totalConfirmedCount: json["totalConfirmedCount"],
        totalConfirmedAmount: json["totalConfirmedAmount"],
        fromDateTime: json["fromDateTime"],
        toDateTime: json["toDateTime"],
        courierBalance: json["courierBalance"],
        courierLastDepositDate: json["courierLastDepositDate"] ?? "",
        courierCode: json["courierCode"] ?? "");
  }

  // Modeldan JSON ga o'tkazish
  Map<String, dynamic> toJson() {
    return {
      "courierId": courierId,
      "courierFullName": courierFullName,
      "courierUserName": courierUserName,
      "courierRegionName": courierRegionName,
      "courierStructureName": courierStructureName,
      "totalAcceptedCount": totalAcceptedCount,
      "totalAcceptedAmount": totalAcceptedAmount,
      "totalWaitingCount": totalWaitingCount,
      "totalWaitingAmount": totalWaitingAmount,
      "totalConfirmedCount": totalConfirmedCount,
      "totalConfirmedAmount": totalConfirmedAmount,
      "fromDateTime": fromDateTime,
      "toDateTime": toDateTime,
      "courierBalance": courierBalance,
      "courierLastDepositDate": courierLastDepositDate,
    };
  }
}

// JSON dan modelga o‘tkazish
CourierData parseCourierData(String jsonString) {
  final Map<String, dynamic> jsonMap = json.decode(jsonString)["data"];
  return CourierData.fromJson(jsonMap);
}
