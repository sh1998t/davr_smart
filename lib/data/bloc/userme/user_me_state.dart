part of 'user_me_cubit.dart';

@immutable
abstract class UserMeState {}

class UserMeInitial extends UserMeState {}

class UserMeLoading extends UserMeState {}

class UserMeLoaded extends UserMeState {
  final UserMeModel userMe;
  UserMeLoaded(this.userMe);
}

class UserMeError extends UserMeState {
  final String message;
  UserMeError(this.message);
}
