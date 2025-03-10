import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'data_collection_state.dart';

class DataCollectionCubit extends Cubit<DataCollectionState> {
  DataCollectionCubit() : super(DataCollectionInitial());
}
