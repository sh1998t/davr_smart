import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/precessing_api.dart';
import 'package:meta/meta.dart';

import '../../model/deposit_model.dart';

part 'precessing_bloc_state.dart';

class PrecessingBlocCubit extends Cubit<PrecessingBlocState> {
  final PrecessingApi request;

  PrecessingBlocCubit(this.request) : super(PrecessingBlocInitial());

  Future<void> fetchDeposits({int? page}) async {
    emit(PrecessingLoading());
    try {
      final deposits = await request.request(page: page);
      emit(PrecessingData(deposits));
    } catch (e) {
      emit(PrecessingError(e.toString()));
    }
  }
}
