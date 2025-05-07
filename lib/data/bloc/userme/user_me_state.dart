part of 'user_me_cubit.dart';

@immutable
abstract class UserMeState {}

class UserMeInitial extends UserMeState {}

class UserMeLoading extends UserMeState {}

class UserMeData extends UserMeState {
  final UserMeModel userMe;
  UserMeData(this.userMe);
}

class UserMeError extends UserMeState {
  final String message;
  UserMeError(this.message);
}
