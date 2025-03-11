part of 'precessing_bloc_cubit.dart';

@immutable
sealed class PrecessingBlocState {}

final class PrecessingBlocInitial extends PrecessingBlocState {}

class PrecessingLoading extends PrecessingBlocState {}

class PrecessingData extends PrecessingBlocState {
  final List<DepositReplenishmentsModel> deposits;
  PrecessingData(this.deposits);
}

final class PrecessingError extends PrecessingBlocState {
  final String message;
  PrecessingError(this.message);
}
