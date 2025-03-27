import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/deposit_api.dart';
import 'package:meta/meta.dart';

import '../../model/deposit_model.dart';

part 'deposit_state.dart';

class DepositCubit extends Cubit<DepositState> {
  final DepositReplenishmentsListRequest request;
  DepositCubit(this.request) : super(DepositInitial());

  Map<String, dynamic> _depositList = {
    'items': <DepositReplenishmentsModel>[],
    'totalCount': 0,
    'pageCount': 0,
    'currentPage': 0,
    'perPage': 0,
  };

  Future<void> fetchDeposits({int? page}) async {
    try {
      if (page == null || page == 1) {
        emit(DepositLoading());
      }

      final newData = await request.request(page: page);
      final newItems = List<DepositReplenishmentsModel>.from(newData['items']);

      if (page == null || page == 1) {
        _depositList = newData;
      } else {
        final currentItems =
            List<DepositReplenishmentsModel>.from(_depositList['items']);
        if (currentItems.length < (_depositList['totalCount'] as int)) {
          _depositList['items'] = [...currentItems, ...newItems];
          _depositList['currentPage'] = newData['currentPage'];
        }
      }

      print(
          'Umumiy elementlar: ${_depositList['items'].length}, Total: ${_depositList['totalCount']}');
      emit(DepositData(
        deposits: List.from(_depositList['items']),
        totalCount: _depositList['totalCount'] as int,
        pageCount: _depositList['pageCount'] as int,
        currentPage: _depositList['currentPage'] as int,
      ));
    } catch (e) {
      emit(DepositError(e.toString()));
    }
  }
}
