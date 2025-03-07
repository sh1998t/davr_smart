import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/response/auth_response.dart';
import '../network/api/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  final FlutterSecureStorage secureStorage;

  AuthRepository(this.authService, this.secureStorage);

  Future<AuthResponse> login(String login, String password) async {
    final response = await authService.login(login, password);
    await secureStorage.write(key: 'token', value: response.token);
    return response;
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'token');
  }
}
