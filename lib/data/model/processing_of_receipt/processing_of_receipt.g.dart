// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processing_of_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataItem _$DataItemFromJson(Map<String, dynamic> json) => DataItem(
      id: (json['id'] as num).toInt(),
      operator_code: json['operator_code'] as String,
      courier_code: json['courier_code'] as String?,
      user_id: User.fromJson(json['user_id'] as Map<String, dynamic>),
      to_user_id: json['to_user_id'],
      confirm_user_id: json['confirm_user_id'],
      operator_photo: json['operator_photo'] as String,
      courier_photo: json['courier_photo'] as String?,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      comment: json['comment'] as String?,
      region_id: Region.fromJson(json['region_id'] as Map<String, dynamic>),
      structure_id:
          Structure.fromJson(json['structure_id'] as Map<String, dynamic>),
      amount_type: Status.fromJson(json['amount_type'] as Map<String, dynamic>),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      bank_id: (json['bank_id'] as num).toInt(),
      stage: Status.fromJson(json['stage'] as Map<String, dynamic>),
      condition: (json['condition'] as num).toInt(),
      created_at:
          Timestamp.fromJson(json['created_at'] as Map<String, dynamic>),
      updated_at:
          Timestamp.fromJson(json['updated_at'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataItemToJson(DataItem instance) => <String, dynamic>{
      'id': instance.id,
      'operator_code': instance.operator_code,
      'courier_code': instance.courier_code,
      'user_id': instance.user_id,
      'to_user_id': instance.to_user_id,
      'confirm_user_id': instance.confirm_user_id,
      'operator_photo': instance.operator_photo,
      'courier_photo': instance.courier_photo,
      'amount': instance.amount,
      'currency': instance.currency,
      'comment': instance.comment,
      'region_id': instance.region_id,
      'structure_id': instance.structure_id,
      'amount_type': instance.amount_type,
      'status': instance.status,
      'bank_id': instance.bank_id,
      'stage': instance.stage,
      'condition': instance.condition,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      login: json['login'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'code': instance.code,
    };

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      intValue: (json['intValue'] as num).toInt(),
      data: RegionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'intValue': instance.intValue,
      'data': instance.data,
    };

RegionData _$RegionDataFromJson(Map<String, dynamic> json) => RegionData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RegionDataToJson(RegionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Structure _$StructureFromJson(Map<String, dynamic> json) => Structure(
      intValue: (json['intValue'] as num).toInt(),
      data: RegionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StructureToJson(Structure instance) => <String, dynamic>{
      'intValue': instance.intValue,
      'data': instance.data,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      intValue: (json['intValue'] as num).toInt(),
      string: json['string'] as String,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'intValue': instance.intValue,
      'string': instance.string,
    };

Timestamp _$TimestampFromJson(Map<String, dynamic> json) => Timestamp(
      timestamp: (json['timestamp'] as num).toInt(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$TimestampToJson(Timestamp instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'date': instance.date,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      current_page: (json['current_page'] as num).toInt(),
      total_pages: (json['total_pages'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      per_page: (json['per_page'] as num).toInt(),
      links: PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current_page': instance.current_page,
      'total_pages': instance.total_pages,
      'total': instance.total,
      'per_page': instance.per_page,
      'links': instance.links,
    };

PaginationLinks _$PaginationLinksFromJson(Map<String, dynamic> json) =>
    PaginationLinks(
      first: json['first'] as String,
      last: json['last'] as String,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );

Map<String, dynamic> _$PaginationLinksToJson(PaginationLinks instance) =>
    <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };
