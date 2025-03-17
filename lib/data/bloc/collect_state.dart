part of 'collect_cubit.dart';

@immutable
sealed class CollectState {}

final class CollectInitial extends CollectState {}

class CollectData extends CollectState {
  final List<int> bankIds;
  final List<String> imagePaths;

  CollectData({
    required this.bankIds,
    required this.imagePaths,
  });
}
