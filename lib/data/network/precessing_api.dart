import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';
import '../model/deposit_model.dart';

class PrecessingApi extends BaseApiRequest {
  static const int limit = 20;

  Future<Map<String, dynamic>> request(int? page) async {
    final currentPage = page ?? 1;
    var endPoint = '${ApiConst.new_deposit}?page=$currentPage&limit=$limit';
    final response = await super.getRequest(endPoint);

    print('API javobi (Page $currentPage): ${response?.data}'); // Debug

    if (response?.statusCode != 200) {
      throw Exception('Server xatosi: ${response?.statusCode}');
    }

    Map<String, dynamic> replenishmentList = {};
    var pagination = response?.data['pagination'] ?? {};

    replenishmentList['totalCount'] = pagination['total'] ?? 0;
    replenishmentList['pageCount'] = pagination['total_pages'] ?? 0;
    replenishmentList['currentPage'] = pagination['current_page'] ?? 0;
    replenishmentList['perPage'] = pagination['per_page'] ?? limit;

    List<DepositReplenishmentsModel> replenishments = [];
    var data = response?.data['data'] ?? [];
    print('Ma’lumotlar soni (Page $currentPage): ${data.length}'); // Debug
    for (final item in data) {
      replenishments.add(DepositReplenishmentsModel.fromJson(item));
    }

    replenishmentList['items'] = replenishments;
    return replenishmentList;
  }
}
