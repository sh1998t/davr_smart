import 'package:dio/dio.dart';
import 'package:incasator/%20core/api_const.dart';
import 'package:incasator/%20core/base_api_requrest.dart';

class DepositSend extends BaseApiRequest {
  Future<bool> request(
    int? depositId,
    String? chekPhoto,
    int? bankId,
  ) async {
    var formMap = {
      'deposit_id': depositId ?? '',
      'bank_id': bankId ?? 0,
    };

    if (chekPhoto != null && chekPhoto.isNotEmpty) {
      print(chekPhoto);
      formMap['courier_photo'] = [
        await MultipartFile.fromFile(chekPhoto, filename: chekPhoto)
      ];
    }

    var data = FormData.fromMap(formMap);
    final endpoint = "${ApiConst.Deposit_Send}";
    final response = await super.postMultipartRequest(endpoint, data);
    print(response);
    if (response != null && response.data != null) {
      if (response.data['error'] != null) {
        throw (response.data['error']['message']);
      }
    }
    return true;
  }
}
