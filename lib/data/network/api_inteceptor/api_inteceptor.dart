import 'package:dio/dio.dart';

import '../../reporisitory/token_repository.dart';

class AuthorizedRequestInterceptor extends Interceptor {
  final Dio dio;
  final TokenRepository tokenRepository;

  AuthorizedRequestInterceptor(this.dio, this.tokenRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${tokenRepository.getToken()}';
    super.onRequest(options, handler);
  }
}

class CommonRequestInterceptor extends Interceptor {
  final Dio dio;

  CommonRequestInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }
}
