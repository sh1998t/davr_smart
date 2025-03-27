import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';
import '../model/deposit_model.dart';

class DepositReplenishmentsListRequest extends BaseApiRequest {
  static const int limit = 20; // Har sahifada 20 ta ma'lumot

  Future<Map<String, dynamic>> request({int? page}) async {
    final currentPage = page ?? 1;
    var endPoint =
        '${ApiConst.Get_Accepted_deposit}?page=$currentPage&limit=$limit';

    final response = await super.getRequest(endPoint);

    if (response?.statusCode != 200) {
      throw Exception(response?.data['message'] ?? 'Server xatosi');
    }

    Map<String, dynamic> result = {};
    var pagination = response?.data['pagination'] ?? {};
    var data = response?.data['data'] ?? [];

    result['items'] = data
        .map<DepositReplenishmentsModel>(
            (item) => DepositReplenishmentsModel.fromJson(item))
        .toList();
    result['totalCount'] = pagination['total'] ?? 0;
    result['pageCount'] = pagination['total_pages'] ?? 0;
    result['currentPage'] = pagination['current_page'] ?? currentPage;
    result['perPage'] = pagination['per_page'] ?? limit;

    print(
        'API javobi (Page $currentPage): Items: ${result['items'].length}, Total: ${result['totalCount']}');
    return result;
  }
}
