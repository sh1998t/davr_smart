import 'package:bloc/bloc.dart';
import 'package:incasator/data/model/statistika_model.dart';
import 'package:incasator/data/network/statistika_api.dart';
import 'package:meta/meta.dart';

part 'statistika__state.dart';

class StatistikaCubit extends Cubit<StatistikaState> {
  final StatistikaApi statistikaApi;
  StatistikaCubit(this.statistikaApi) : super(StatistikaInitial());
  Future<void> data(int userId) async {
    emit(StatistikaLoading());
    try {
      final data = await statistikaApi.request(userId);
      emit(StatistikaData(data));
    } catch (Error) {
      emit(StatistikaError(Error.toString()));
    }
  }
}
