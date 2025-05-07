import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';
import '../model/statistika_model.dart';

class StatistikaApi extends BaseApiRequest {
  Future<CourierData> request(int userId) async {
    try {
      var url = ApiConst.Statistika;
      final response = await super
          .postRequest(url, {"userId": userId, "staticTime": "today"});
      if (response == null || response.statusCode != 200) {
        final errorMessage =
            response?.data != null && response.data['success'] == false
                ? response.data['error']?.toString() ??
                    'Server xatosi: success false qaytdi'
                : 'Serverdan xato javob: ${response?.statusCode ?? "null"}';
        throw Exception(errorMessage);
      }
      return CourierData.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
