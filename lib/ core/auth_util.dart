import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/model/statistika_model.dart';
import '../data/network/statistika_api.dart';
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

  static Future<CourierData> checkIsAuth() {
    return (StatistikaApi()).request(3);
  }
}
