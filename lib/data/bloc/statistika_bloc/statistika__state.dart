part of 'statistika__cubit.dart';

@immutable
sealed class StatistikaState {}

final class StatistikaInitial extends StatistikaState {}

final class StatistikaLoading extends StatistikaState {}

final class StatistikaError extends StatistikaState {
  final String error;
  StatistikaError(this.error);
}

final class StatistikaData extends StatistikaState {
  final CourierData data;
  StatistikaData(this.data);
}
