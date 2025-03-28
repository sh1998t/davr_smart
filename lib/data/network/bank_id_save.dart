import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';

class BankIdSave extends BaseApiRequest {
  Future<bool> bankIdRequest() async {
    var url = ApiConst.Bank_id;
    try {
      final response = await super.getRequest(url);

      if (response == null || response.statusCode != 200) {
        final errorMessage = response?.data['message'] ?? 'Server xatosi';
        throw Exception(errorMessage);
      }

      var data = response.data['data'] ?? [];

      await _saveToSharedPreferences(data);

      return true;
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorMessage = e.response!.data['message'] ?? 'Tarmoq xatosi';
        throw Exception(errorMessage);
      }
      throw Exception(e.toString());
    }
  }

  Future<void> _saveToSharedPreferences(List<dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    String jsonString = jsonEncode(data);

    await prefs.setString('bank_id_data', jsonString);
  }

  Future<List<dynamic>> getBankIdData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('bank_id_data');

    if (jsonString != null) {
      return jsonDecode(jsonString) as List<dynamic>;
    }
    return [];
  }
}
