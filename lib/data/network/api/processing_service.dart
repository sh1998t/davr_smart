import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../core/api_const/api_const.dart';
import '../../model/response/processing_response.dart';

part 'processing_service.g.dart';

@RestApi(baseUrl: ApiConst.base_Url)
abstract class ProcessingService {
  factory ProcessingService(Dio dio, {String baseUrl}) = _ProcessingService;
  @GET(ApiConst.ProcessingOfReceiptUrl)
  Future<ApiResponse> getOperatorDeposits();
}
