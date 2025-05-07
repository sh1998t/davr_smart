import 'package:incasator/data/model/bank_model.dart';

import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';

class BankApi extends BaseApiRequest {
  static const int limit = 20;

  Future<Map<String, dynamic>> request() async {
    var endPoint = '${ApiConst.new_deposit}?limit=$limit';
    final response = await super.getRequest(endPoint);

    if (response?.statusCode != 200) {
      throw Exception('Server xatosi: ${response?.statusCode}');
    }

    Map<String, dynamic> replenishmentList = {};
    var pagination = response?.data['pagination'] ?? {};

    replenishmentList['totalCount'] = pagination['total'] ?? 0;
    replenishmentList['pageCount'] = pagination['total_pages'] ?? 0;
    replenishmentList['currentPage'] = pagination['current_page'] ?? 0;
    replenishmentList['perPage'] = pagination['per_page'] ?? limit;

    List<BankModel> replenishments = [];
    var data = response?.data['data'] ?? [];
    for (final item in data) {
      replenishments.add(BankModel.fromJson(item));
    }

    replenishmentList['items'] = replenishments;
    return replenishmentList;
  }
}
