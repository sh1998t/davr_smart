import 'package:json_annotation/json_annotation.dart';

part 'processing_of_receipt.g.dart';

@JsonSerializable()
class DataItem {
  final int id;
  final String operator_code;
  final String? courier_code;
  final User user_id;
  final dynamic to_user_id;
  final dynamic confirm_user_id;
  final String operator_photo;
  final String? courier_photo;
  final int amount;
  final String currency;
  final String? comment;
  final Region region_id;
  final Structure structure_id;
  final Status amount_type;
  final Status status;
  final int bank_id;
  final Status stage;
  final int condition;
  final Timestamp created_at;
  final Timestamp updated_at;

  DataItem({
    required this.id,
    required this.operator_code,
    this.courier_code,
    required this.user_id,
    this.to_user_id,
    this.confirm_user_id,
    required this.operator_photo,
    this.courier_photo,
    required this.amount,
    required this.currency,
    this.comment,
    required this.region_id,
    required this.structure_id,
    required this.amount_type,
    required this.status,
    required this.bank_id,
    required this.stage,
    required this.condition,
    required this.created_at,
    required this.updated_at,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) =>
      _$DataItemFromJson(json);
  Map<String, dynamic> toJson() => _$DataItemToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String login;
  final String code;

  User({required this.id, required this.login, required this.code});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Region {
  final int intValue;
  final RegionData data;

  Region({required this.intValue, required this.data});

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

@JsonSerializable()
class RegionData {
  final int id;
  final String name;

  RegionData({required this.id, required this.name});

  factory RegionData.fromJson(Map<String, dynamic> json) =>
      _$RegionDataFromJson(json);
  Map<String, dynamic> toJson() => _$RegionDataToJson(this);
}

@JsonSerializable()
class Structure {
  final int intValue;
  final RegionData data;

  Structure({required this.intValue, required this.data});

  factory Structure.fromJson(Map<String, dynamic> json) =>
      _$StructureFromJson(json);
  Map<String, dynamic> toJson() => _$StructureToJson(this);
}

@JsonSerializable()
class Status {
  final int intValue;
  final String string;

  Status({required this.intValue, required this.string});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class Timestamp {
  final int timestamp;
  final String date;

  Timestamp({required this.timestamp, required this.date});

  factory Timestamp.fromJson(Map<String, dynamic> json) =>
      _$TimestampFromJson(json);
  Map<String, dynamic> toJson() => _$TimestampToJson(this);
}

@JsonSerializable()
class Pagination {
  final int current_page;
  final int total_pages;
  final int total;
  final int per_page;
  final PaginationLinks links;

  Pagination({
    required this.current_page,
    required this.total_pages,
    required this.total,
    required this.per_page,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class PaginationLinks {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  PaginationLinks({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationLinksToJson(this);
}
