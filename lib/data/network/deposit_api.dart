import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';
import '../model/deposit_model.dart';

class DepositReplenishmentsListRequest extends BaseApiRequest {
  Future<List<DepositReplenishmentsModel>> request({int? page}) async {
    var endPoint = ApiConst.new_deposit;
    final response = await super.getRequest(endPoint);
    print(response);
    if (response.statusCode != 200) {
      throw Exception('Server xatosi: success false qaytdi');
    }

    var data = response?.data['data'] ?? [];
    return data
        .map<DepositReplenishmentsModel>(
            (item) => DepositReplenishmentsModel.fromJson(item))
        .toList();
  }
}
