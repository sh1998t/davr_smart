import 'dart:async';

import 'package:dio/dio.dart';

import 'api_const.dart';
import 'auth_util.dart';

class BaseApiRequest {
  Future<Dio> initRequest(List<Map<String, String>>? headers) async {
    final options = BaseOptions(
      baseUrl: ApiConst.base_Url,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
    );
    final dio = Dio(options);
    if (headers!.isNotEmpty) {
      for (var element in headers) {
        element.forEach((key, value) {
          dio.options.headers[key] = value;
        });
      }
    } else {}
    final token = await AuthUtil.getToken();
    dio.options.headers['Authorization'] = "Bearer $token";
    return dio;
  }

  Future getRequest(String url) async {
    final dio = await initRequest([]);
    return dio.get(
      url,
    );
  }

  Future getFilterRequest(
      String url, Map<String, dynamic>? queryParameters) async {
    final dio = await initRequest([]);
    return dio.get(url, queryParameters: queryParameters);
  }

  Future postRequest(String url, Object? data) async {
    final dio = await initRequest([]);
    return dio.post(url, data: data);
  }

  Future postMultipartRequest(String url, Object? data) async {
    final dio = await initRequest([
      {"Content-Type": "multipart/form-data"}
    ]);
    return dio.post(url, data: data);
  }
}
