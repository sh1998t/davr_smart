import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:incasator/data/network/user_me.dart';

import '../data/model/user_model.dart';
import 'api_const.dart';

class AuthUtil {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: ApiConst.token);
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  static Future<void> setToken(String? token) async {
    try {
      if (token != null) {
        await _storage.write(key: ApiConst.token, value: token);
      } else {
        // Agar null bo‘lsa, mavjud tokenni o‘chirish
        await _storage.delete(key: ApiConst.token);
      }
    } catch (e) {
      print('Error writing token: $e');
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: ApiConst.token);
    } catch (e) {
      print('Error deleting token: $e');
    }
  }

  static Future<UserMeModel> checkIsAuth() {
    return (UserMeRequest()).request();
  }
}
