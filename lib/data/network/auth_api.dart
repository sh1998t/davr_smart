import 'package:dio/dio.dart';

import '../../ core/api_const.dart';
import '../../ core/auth_util.dart';
import '../../ core/base_api_requrest.dart';

class AuthApiRequest extends BaseApiRequest {
  Future<bool> request(
    String? login,
    String? password,
  ) async {
    try {
      final response = await super.postRequest(
          ApiConst.login, {"login": login, "password": password, "role": 5});
      if (response == null) {
        throw Exception("Javob kelmedi!");
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.statusCode == 401) {
          if (response.data['error'] != null) {
            throw Exception(response.data['error']['message'] ??
                "Login yoki parol noto‘g‘ri");
          }
          throw Exception("Login yoki parol noto‘g‘ri");
        }

        if (response.data['error'] != null) {
          throw Exception(
              response.data['error']['message'] ?? "Xatolik yuz berdi");
        }
        throw Exception("Server xatosi: ${response.statusCode}");
      }

      if (response.data['success'] == false) {
        throw Exception(
            response.data['error']['message'] ?? "Noma'lum xatolik");
      }

      final String? token = response.data['data']?['token'];
      if (token == null) {
        throw Exception("Token mavjud emas!");
      }

      await AuthUtil.setToken(token);
      return true;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response!.data['error'] != null) {
          throw Exception(
              e.response!.data['error']['message'] ?? "Xatolik yuz berdi");
        }
        throw Exception("Tarmoq xatosi: ${e.message}");
      }
      rethrow;
    }
  }
}
