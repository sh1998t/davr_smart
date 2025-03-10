import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/deposit_api.dart';
import 'package:meta/meta.dart';

import '../../model/deposit_model.dart';

part 'deposit_bloc_state.dart';

class DepositBlocCubit extends Cubit<DepositBlocState> {
  final DepositReplenishmentsListRequest request;

  DepositBlocCubit(this.request) : super(DepositBlocInitial());

  Future<void> fetchDeposits({int? page}) async {
    emit(DepositLoading());
    try {
      final deposits = await request.request(page: page);
      emit(DepositData(deposits));
    } catch (e) {
      emit(DepositError(e.toString()));
    }
  }
}
