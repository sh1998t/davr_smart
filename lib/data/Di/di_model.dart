import 'package:dio/dio.dart';
import 'package:incasator/core/api_const/api_const.dart';
import 'package:injectable/injectable.dart';

import '../network/api_inteceptor/api_inteceptor.dart';
import '../reporisitory/token_repository.dart';
import 'di_container.dart';

const _requestTimeoutInMilliseconds = 20000;

@module
abstract class DioModule {
  @Named("Host")
  String get host => ApiConst.base_Url;

  @singleton
  Future<Dio> getAuthorizedDioClient({
    required TokenRepository tokenRepository,
  }) async {
    final authorizedDioClient = _createDioClient(ApiConst.base_Url);
    authorizedDioClient.interceptors.addAll([
      AuthorizedRequestInterceptor(
        authorizedDioClient,
        inject(),
      ),
    ]);
    return authorizedDioClient;
  }

  @Named("UnauthorizedClient")
  @singleton
  Future<Dio> getUnauthorizedDioClient({
    @Named("Host") required String host,
  }) async {
    final unauthorizedDioClient = _createDioClient(ApiConst.base_Url);
    unauthorizedDioClient.interceptors.addAll([
      CommonRequestInterceptor(
        unauthorizedDioClient,
      ),
    ]);
    return unauthorizedDioClient;
  }

  Dio _createDioClient(
    String baseUrl, {
    int requestTimeoutInMilliseconds = _requestTimeoutInMilliseconds,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(milliseconds: requestTimeoutInMilliseconds),
      receiveTimeout: Duration(milliseconds: requestTimeoutInMilliseconds),
    );
    return Dio(options);
  }
}
