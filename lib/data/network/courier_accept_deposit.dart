import 'package:incasator/%20core/base_api_requrest.dart';

import '../../ core/api_const.dart';

class CourierAcceptDeposit extends BaseApiRequest {
  Future<bool> request(String depositId) async {
    var endPoint = ApiConst.Courier_Accept_Deposit;
    final response =
        await super.getFilterRequest(endPoint, {"depositId": depositId});
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Server xatosi: success false qaytdi');
    }

    var data = response?.data['data'] ?? [];
    return data;
  }
}
