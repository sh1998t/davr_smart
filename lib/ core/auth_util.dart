import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_const.dart';

class AuthUtil {
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: ApiConst.token);
    return value;
  }

  static Future<String?> setToken(String? token) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: ApiConst.token, value: token);
    return null;
  }
}
