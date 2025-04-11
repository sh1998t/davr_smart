import 'package:dio/dio.dart';
import 'package:incasator/%20core/base_api_requrest.dart';

import '../../ core/api_const.dart';

class GetCancelDeposit extends BaseApiRequest {
  Future<bool> request(int? id) async {
    var endPoint = ApiConst.Get_Cancel_deposit;
    try {
      final response = await super.getFilterRequest(endPoint, {"id": id});
      print("data  ==== ==== = == = $response");
      if (response == null || response.statusCode != 200) {
        final errorMessage = response?.data['message'] ?? 'Server xatosi';
        throw Exception(errorMessage);
      }
      if (response.data['success'] == false) {
        final errorMessage = response.data['message'] ?? 'Xatolik yuz berdi';
        throw Exception(errorMessage);
      }
      var data = response.data['data'] ?? [];
      return true;
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response!.data['message'] ?? 'Tarmoq xatosi';
        throw Exception(errorMessage);
      }
      throw Exception(e.toString());
    }
  }
}
