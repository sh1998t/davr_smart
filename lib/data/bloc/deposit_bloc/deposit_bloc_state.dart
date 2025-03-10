part of 'deposit_bloc_cubit.dart';

@immutable
sealed class DepositBlocState {}

final class DepositBlocInitial extends DepositBlocState {}

final class DepositLoading extends DepositBlocState {}

class DepositData extends DepositBlocState {
  final List<DepositReplenishmentsModel> deposits;
  DepositData(this.deposits);
}

final class DepositError extends DepositBlocState {
  final String message;
  DepositError(this.message);
}
