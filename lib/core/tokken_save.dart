// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:incasator/core/api_const/api_const.dart';
//
// class SecureStorage {
//   final _storage = const FlutterSecureStorage();
//
//   Future<void> saveToken(String token) async {
//     await _storage.write(key: ApiConst.token, value: token);
//   }
//
//   Future<String?> getToken() async {
//     return await _storage.read(key: ApiConst.token);
//   }
//
//   Future<void> deleteToken() async {
//     await _storage.delete(key: ApiConst.token);
//   }
// }
//
// class SecureStorageImpl implements SecureStorage {
//   final _storage = const FlutterSecureStorage();
//
//   @override
//   Future<void> saveToken(String token) async {
//     await _storage.write(key: ApiConst.token, value: token);
//   }
//
//   @override
//   Future<String?> getToken() async {
//     return await _storage.read(key: ApiConst.token);
//   }
//
//   @override
//   Future<void> deleteToken() async {
//     await _storage.delete(key: ApiConst.token);
//   }
// }
//
// // ApiConst ni misol sifatida qo'shamiz (sizda bu sinf allaqachon bor deb o'ylayman)
