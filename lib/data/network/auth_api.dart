import '../../ core/api_const.dart';
import '../../ core/auth_util.dart';
import '../../ core/base_api_requrest.dart';

class AuthApiRequest extends BaseApiRequest {
  Future request(
    String login,
    String password,
  ) async {
    final response = await super.postRequest(ApiConst.login, {
      "login": login,
      "password": password,
    });

    if (response?.data['error'] != null) {
      throw (response?.data['message']);
    }
    final String token = response?.data['token'];
    AuthUtil.setToken(token);

    return response;
  }
}
