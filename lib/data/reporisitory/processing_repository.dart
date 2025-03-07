import 'package:incasator/data/model/response/processing_response.dart';
import 'package:incasator/data/network/api/processing_service.dart';

class ProcessingRepository {
  final ProcessingService _service;
  ProcessingRepository(this._service);
  Future<ApiResponse> getDeposits() async {
    try {
      final response = await _service.getOperatorDeposits();
      return response;
    } catch (error) {
      throw Exception("Xatolik $error");
    }
  }
}
