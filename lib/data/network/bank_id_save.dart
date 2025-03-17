import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../ core/api_const.dart';
import '../../ core/base_api_requrest.dart';

class BankIdSave extends BaseApiRequest {
  Future<bool> bankIdRequest() async {
    var url = ApiConst.Bank_id;
    final response = await super.getRequest(url);

    if (response.statusCode != 200) {
      throw Exception('Serverdan xato javob keldi: ${response.statusCode}');
    }

    var data = response?.data['data'] ?? [];

    await _saveToSharedPreferences(data);

    return true;
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
