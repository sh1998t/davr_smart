import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AppPreference {
  final SharedPreferences _prefs;

  AppPreference(this._prefs);

  String? getToken() => _prefs.getString('token');

  void saveToken(String token) => _prefs.setString('token', token);
}
