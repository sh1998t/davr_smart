part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthData extends AuthState {
  final String token;
  final String massage;
  AuthData(this.massage, this.token);
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
