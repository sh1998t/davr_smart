import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:incasator/data/model/deposit_model.dart';
import 'package:incasator/data/network/precessing_api.dart';
import 'package:meta/meta.dart';

part 'precessing_bloc_state.dart';

class ProcessingCubit extends Cubit<ProcessingState> {
  final PrecessingApi precessingApi;
  ProcessingCubit(this.precessingApi) : super(ProcessingInitial());
  Map<String, dynamic> _replenishmentList = {
    'items': <DepositReplenishmentsModel>[],
    'totalCount': 0,
    'pageCount': 0,
    'currentPage': 0,
    'perPage': 0,
  };
  Future<void> fetchProcessing({int? page}) async {
    try {
      if (page == null || page == 1) {
        emit(ProcessingLoading());
      }

      final newData = await precessingApi.request(page);
      final newItems = List<DepositReplenishmentsModel>.from(newData['items']);
      if (page == null || page == 1) {
        _replenishmentList = newData;
      } else {
        final currentItems =
            List<DepositReplenishmentsModel>.from(_replenishmentList['items']);
        if (currentItems.length < (_replenishmentList['totalCount'] as int)) {
          _replenishmentList['items'] = [...currentItems, ...newItems];
          _replenishmentList['currentPage'] = newData['currentPage'];
        }
      }
      emit(ProcessingLoaded(
          Map.from(_replenishmentList), _replenishmentList['currentPage']));
    } catch (e) {
      emit(ProcessingError(e.toString()));
    }
  }
}
