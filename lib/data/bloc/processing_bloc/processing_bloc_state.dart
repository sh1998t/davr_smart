part of 'processing_bloc_cubit.dart';

@immutable
sealed class ProcessingBlocState {}

final class ProcessingBlocInitial extends ProcessingBlocState {}

final class ProcessingBlocLoading extends ProcessingBlocState {}

final class ProcessingBlocData extends ProcessingBlocState {
  final ApiResponse apiResponse;
  ProcessingBlocData(this.apiResponse);
}

final class ProcessingBlocError extends ProcessingBlocState {
  final String massage;
  ProcessingBlocError(this.massage);
}
