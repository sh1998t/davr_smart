import 'package:dio/dio.dart';

import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';

class AuthApiRequest extends BaseApiRequest {
  Future<String> request(
    String? login,
    String? password,
  ) async {
    try {
      final response = await super.postRequest(
        ApiConst.login,
        {"login": login, "password": password, "role": 5},
      );

      if (response == null) throw Exception("Javob kelmadi!");

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.statusCode == 401) {
          throw Exception(response.data['error']?['message'] ??
              "Login yoki parol noto‘g‘ri");
        }
        throw Exception(response.data['error']?['message'] ??
            "Server xatosi: ${response.statusCode}");
      }

      if (response.data['success'] == false) {
        throw Exception(
            response.data['error']?['message'] ?? "Noma'lum xatolik");
      }

      final String? token = response.data['data']?['token'];
      if (token == null) {
        throw Exception("Token mavjud emas!");
      }

      return token;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['error']?['message'] ??
            "Tarmoq xatosi: ${e.message}");
      }
      rethrow;
    }
  }
}
