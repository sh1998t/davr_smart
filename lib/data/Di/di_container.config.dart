// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:incasator/data/Di/di_model.dart' as _i1022;
import 'package:incasator/data/reporisitory/token_repository.dart' as _i119;
import 'package:incasator/data/storage/app_preference.dart' as _i1006;
import 'package:incasator/data/storage/storage_module.dart' as _i750;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final storageModule = _$StorageModule();
    final dioModule = _$DioModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => storageModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i1006.AppPreference>(
        () => _i1006.AppPreference(gh<_i460.SharedPreferences>()));
    gh.factory<String>(
      () => dioModule.host,
      instanceName: 'Host',
    );
    gh.singletonAsync<_i361.Dio>(() => dioModule.getAuthorizedDioClient(
        tokenRepository: gh<_i119.TokenRepository>()));
    gh.singletonAsync<_i361.Dio>(
      () => dioModule.getUnauthorizedDioClient(
          host: gh<String>(instanceName: 'Host')),
      instanceName: 'UnauthorizedClient',
    );
    return this;
  }
}

class _$StorageModule extends _i750.StorageModule {}

class _$DioModule extends _i1022.DioModule {}
