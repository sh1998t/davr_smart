import 'package:json_annotation/json_annotation.dart';

import '../processing_of_receipt/processing_of_receipt.dart';

part 'processing_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool success;
  final List<DataItem> data;
  final Pagination pagination;

  ApiResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
