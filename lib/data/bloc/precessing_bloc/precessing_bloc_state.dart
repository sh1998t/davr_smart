part of 'precessing_bloc_cubit.dart';

@immutable
abstract class PrecessingBlocState {}

class PrecessingBlocInitial extends PrecessingBlocState {}

class PrecessingLoading extends PrecessingBlocState {}

class PrecessingData extends PrecessingBlocState {
  final List<DepositReplenishmentsModel> items;
  final int totalCount;
  final int pageCount;
  final int currentPage;
  final int perPage;

  PrecessingData({
    required Map<String, dynamic> data,
  })  : items = data['items'] ?? [],
        totalCount = data['totalCount'] ?? 0,
        pageCount = data['pageCount'] ?? 0,
        currentPage = data['currentPage'] ?? 1,
        perPage = data['perPage'] ?? 0;

  PrecessingData copyWith({
    List<DepositReplenishmentsModel>? items,
    int? totalCount,
    int? pageCount,
    int? currentPage,
    int? perPage,
  }) {
    return PrecessingData(
      data: {
        'items': items ?? this.items,
        'totalCount': totalCount ?? this.totalCount,
        'pageCount': pageCount ?? this.pageCount,
        'currentPage': currentPage ?? this.currentPage,
        'perPage': perPage ?? this.perPage,
      },
    );
  }
}

class PrecessingError extends PrecessingBlocState {
  final String message;

  PrecessingError(this.message);
}
