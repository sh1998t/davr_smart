import 'package:injectable/injectable.dart';

import '../storage/app_preference.dart';

@singleton
abstract class TokenRepository {
  String? getToken();
  void saveToken(String token);
}

@Singleton(as: TokenRepository)
class TokenRepositoryImpl implements TokenRepository {
  final AppPreference appPreference;

  TokenRepositoryImpl(this.appPreference);

  @override
  String? getToken() => appPreference.getToken();

  @override
  void saveToken(String token) => appPreference.saveToken(token);
}
