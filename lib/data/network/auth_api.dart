import '../../ core/api_const.dart';
import '../../ core/auth_util.dart';
import '../../ core/base_api_requrest.dart';

class AuthApiRequest extends BaseApiRequest {
  Future<bool> request(
    String? login,
    String? password,
  ) async {
    final response = await super.postRequest(
        ApiConst.login, {"login": login, "password": password, "role": 5});

    if (response == null) {
      throw Exception("Javob kelmedi!");
    }

    if (response.statusCode == 401) {
      throw Exception("Login yoki parol noto‘g‘ri");
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      if (response.data['error'] != null) {
        throw Exception(response.data['message'] ?? "Xatolik yuz berdi");
      }
      throw Exception("Server xatosi: ${response.statusCode}");
    }

    // Agar error bo'lsa, xabarni tekshirish
    if (response.data['error'] != null) {
      throw Exception(response.data['message'] ?? "Noma'lum xatolik");
    }

    // Tokenni tekshirish
    final String? token = response.data['data']?['token'];
    if (token == null) {
      throw Exception("Token mavjud emas!");
    }
    await AuthUtil.setToken(token);
    return true;
  }
}
