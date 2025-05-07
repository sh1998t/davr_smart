import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../presentation/screens/login_screen.dart';
import 'api_const.dart';
import 'auth_util.dart';

class BaseApiRequest {
  late Dio dio;

  BaseApiRequest() {
    final options = BaseOptions(
      baseUrl: ApiConst.base_Url,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      validateStatus: (status) => true, // MUHIM!
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthUtil.getToken();
        if (token != null) {
          options.headers['Authorization'] = "Bearer $token";
        }
        handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == 401) {
          await AuthUtil.deleteToken();

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
        handler.next(response);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    ));
  }

  Future<Response> getRequest(String url) async {
    return await dio.get(url);
  }

  Future<Response> getFilterRequest(
      String url, Map<String, dynamic>? queryParameters) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> postRequest(String url, Object? data) async {
    return await dio.post(url, data: data);
  }

  Future<Response> postMultipartRequest(String url, Object? data) async {
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    return await dio.post(url, data: data);
  }
}
