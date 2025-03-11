part of 'deposit_cubit.dart';

@immutable
sealed class DepositState {}

final class DepositInitial extends DepositState {}

final class DepositLoading extends DepositState {}

final class DepositData extends DepositState {
  final List<DepositReplenishmentsModel> deposits;
  DepositData(this.deposits);
}

final class DepositError extends DepositState {
  final String message;
  DepositError(this.message);
}
