part of 'auth_bloc_cubit.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

final class AuthLoading extends AuthBlocState {}

final class AuthError extends AuthBlocState {
  final String message;
  AuthError(this.message);
}

final class AuthData extends AuthBlocState {
  final String token;
  AuthData(this.token);
}
