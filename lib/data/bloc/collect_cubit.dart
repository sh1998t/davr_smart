import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'collect_state.dart';

class CollectCubit extends Cubit<CollectState> {
  CollectCubit() : super(CollectInitial());

  List<int> _bankIds = [];
  List<String> _imagePaths = [];

  void addBankId(int bankId) {
    _bankIds.add(bankId);
    emit(CollectData(bankIds: _bankIds, imagePaths: _imagePaths));
  }

  void addChekPhoto(String chekPhoto) {
    _imagePaths.add(chekPhoto);
    emit(CollectData(bankIds: _bankIds, imagePaths: _imagePaths));
  }

  List<int> get bankIds => _bankIds;
  List<String> get imagePaths => _imagePaths;
}
