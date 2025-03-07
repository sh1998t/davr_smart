import 'package:bloc/bloc.dart';
import 'package:incasator/data/model/response/processing_response.dart';
import 'package:incasator/data/reporisitory/processing_repository.dart';
import 'package:meta/meta.dart';

part 'processing_bloc_state.dart';

class ProcessingBlocCubit extends Cubit<ProcessingBlocState> {
  final ProcessingRepository repository;
  ProcessingBlocCubit(this.repository) : super(ProcessingBlocInitial());
  void fetchDeposit() async {
    emit(ProcessingBlocLoading());
    try {
      final response = await repository.getDeposits();
      emit(ProcessingBlocData(response));
    } catch (error) {
      emit(ProcessingBlocError(error.toString()));
    }
  }
}
