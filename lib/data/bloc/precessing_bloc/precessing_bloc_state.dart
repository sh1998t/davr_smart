part of 'precessing_bloc_cubit.dart';

@immutable
abstract class ProcessingState extends Equatable {
  const ProcessingState();

  @override
  List<Object> get props => [];
}

class ProcessingInitial extends ProcessingState {}

class ProcessingLoading extends ProcessingState {}

class ProcessingLoaded extends ProcessingState {
  final Map<String, dynamic> replenishmentList;
  final int currentPage;

  const ProcessingLoaded(this.replenishmentList, this.currentPage);

  @override
  List<Object> get props => [replenishmentList, currentPage];
}

class ProcessingError extends ProcessingState {
  final String message;

  const ProcessingError(this.message);

  @override
  List<Object> get props => [message];
}
