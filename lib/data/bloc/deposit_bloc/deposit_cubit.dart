import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/deposit_api.dart';
import 'package:meta/meta.dart';

import '../../model/deposit_model.dart';

part 'deposit_state.dart';

class DepositCubit extends Cubit<DepositState> {
  final DepositReplenishmentsListRequest request;
  DepositCubit(this.request) : super(DepositInitial());
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
// final PrecessingApi request;
//
//   PrecessingBlocCubit(this.request) : super(PrecessingBlocInitial());
//
//   Future<void> fetchDeposits({int? page}) async {
//     emit(PrecessingLoading());
//     try {
//       final deposits = await request.request(page: page);
//       emit(PrecessingData(deposits));
//     } catch (e) {
//       emit(PrecessingError(e.toString()));
//     }
//   }
