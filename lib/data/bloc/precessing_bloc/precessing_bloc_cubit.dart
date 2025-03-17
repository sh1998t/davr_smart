import 'package:bloc/bloc.dart';
import 'package:incasator/data/network/precessing_api.dart';
import 'package:meta/meta.dart';

import '../../model/deposit_model.dart';

part 'precessing_bloc_state.dart';

class PrecessingBlocCubit extends Cubit<PrecessingBlocState> {
  final PrecessingApi request;
  int currentPage = 1;
  bool isFetching =
      false; // Bir vaqtning o'zida bir nechta so'rovni oldini olish uchun
  List<DepositReplenishmentsModel> allItems = []; // Barcha yuklangan elementlar

  PrecessingBlocCubit(this.request) : super(PrecessingBlocInitial());

  Future<void> fetchDeposits({int? page, bool isLoadMore = false}) async {
    if (isFetching)
      return; // Agar so'rov allaqachon bajarilayotgan bo'lsa, qaytib chiqamiz

    isFetching = true;
    if (!isLoadMore) {
      emit(PrecessingLoading());
      allItems.clear(); // Yangi yuklashda ro'yxatni tozalash
      currentPage = 1;
    }

    try {
      final deposits = await request.request(page: page ?? currentPage);
      final newItems = deposits['items'] as List<DepositReplenishmentsModel>;

      allItems.addAll(newItems); // Yangi elementlarni qo'shish

      emit(PrecessingData(
        data: {
          'items': allItems,
          'totalCount': deposits['totalCount'],
          'pageCount': deposits['pageCount'],
          'currentPage': deposits['currentPage'],
          'perPage': deposits['perPage'],
        },
      ));

      if (isLoadMore) {
        currentPage++; // Keyingi sahifa uchun sahifani oshirish
      }
    } catch (e) {
      if (!isLoadMore) {
        emit(PrecessingError(e.toString()));
      } // Faqat birinchi yuklashda xatolik ko'rsatamiz
    } finally {
      isFetching = false;
    }
  }

  void loadMore() {
    if (state is PrecessingData) {
      final currentState = state as PrecessingData;
      if (currentState.currentPage < currentState.pageCount) {
        fetchDeposits(page: currentPage + 1, isLoadMore: true);
      }
    }
  }
}
