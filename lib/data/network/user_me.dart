import 'package:incasator/%20core/api_const.dart';

import '../../ core/base_api_requrest.dart';
import '../model/user_model.dart';

class UserMeRequest extends BaseApiRequest {
  Future<UserMeModel> request() async {
    final response = await super.getRequest(ApiConst.UserMe);

    if (response?.data['error'] != null) {
      throw Exception(response?.data['error']['message']);
    }

    return UserMeModel.fromJson(response?.data['data']);
  }
}
