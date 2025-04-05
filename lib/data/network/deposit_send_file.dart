import 'package:dio/dio.dart';
import 'package:incasator/%20core/api_const.dart';
import 'package:incasator/%20core/base_api_requrest.dart';

class DepositSendFile extends BaseApiRequest {
  Future<bool> request(
    int? depositId,
    String? chekPhoto,
  ) async {
    var formMap = {
      'deposit_id': depositId ?? '',
    };

    if (chekPhoto != null && chekPhoto.isNotEmpty) {
      print(chekPhoto);
      formMap['courier_photo'] = [
        await MultipartFile.fromFile(chekPhoto, filename: chekPhoto)
      ];
    }

    var data = FormData.fromMap(formMap);
    final endpoint = "${ApiConst.Deposit_Send}";
    try {
      final response = await super.postMultipartRequest(endpoint, data);
      print(response);

      if (response != null && response.data != null) {
        if (response.data['success'] == false) {
          // Xato xabarini olish
          String errorMessage =
              response.data['error']['message'] ?? "Noma'lum xatolik";
          throw Exception(errorMessage); // Exceptionni chiqarish
        }
      }
    } catch (e) {
      // API so'rovidagi xatolikni tutib, xabarni chiqarish
      print("Xatolik: ${e.toString()}");
      throw Exception(e.toString());
    }
    return true;
  }
}
