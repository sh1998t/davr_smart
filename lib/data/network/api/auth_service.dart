import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api_const/api_const.dart';
import '../../model/response/auth_response.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: ApiConst.base_Url)
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST(ApiConst.login)
  Future<AuthResponse> login(
    @Field("login") String username,
    @Field("password") String password,
  );
}
