class UserMeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String login;
  final String? phone;
  final String code;
  final StructureId? structureId;
  final RegionId? regionId;
  final Status? status;
  final Role? role;
  final dynamic paymentBlockType;
  final dynamic telegramChatId;
  final DateInfo? createdAt;
  final DateInfo? updatedAt;

  UserMeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.phone,
    required this.code,
    this.structureId,
    this.regionId,
    this.status,
    this.role,
    this.paymentBlockType,
    this.telegramChatId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserMeModel.fromJson(Map<String, dynamic> json) {
    return UserMeModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      login: json['login'] as String,
      phone: json['phone'] as String?,
      code: json['code'] as String,
      structureId: json['structure_id'] != null
          ? StructureId.fromJson(json['structure_id'])
          : null,
      regionId: json['region_id'] != null
          ? RegionId.fromJson(json['region_id'])
          : null,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      paymentBlockType: json['payment_block_type'],
      telegramChatId: json['telegram_chat_id'],
      createdAt: json['created_at'] != null
          ? DateInfo.fromJson(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateInfo.fromJson(json['updated_at'])
          : null,
    );
  }
}

class StructureId {
  final int? intValue;
  final dynamic data;

  StructureId({this.intValue, this.data});

  factory StructureId.fromJson(Map<String, dynamic> json) {
    return StructureId(
      intValue: json['int'] as int?,
      data: json['data'],
    );
  }
}

class RegionId {
  final int? intValue;

  RegionId({this.intValue});

  factory RegionId.fromJson(Map<String, dynamic> json) {
    return RegionId(
      intValue: json['int'] as int?,
    );
  }
}

class Status {
  final int? intValue;
  final String? stringValue;

  Status({this.intValue, this.stringValue});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      intValue: json['int'] as int?,
      stringValue: json['string'] as String?,
    );
  }
}

class Role {
  final int? intValue;
  final String? stringValue;

  Role({this.intValue, this.stringValue});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      intValue: json['int'] as int?,
      stringValue: json['string'] as String?,
    );
  }
}

class DateInfo {
  final int? timestamp;
  final String? date;

  DateInfo({this.timestamp, this.date});

  factory DateInfo.fromJson(Map<String, dynamic> json) {
    return DateInfo(
      timestamp: json['timestamp'] as int?,
      date: json['date'] as String?,
    );
  }
}
