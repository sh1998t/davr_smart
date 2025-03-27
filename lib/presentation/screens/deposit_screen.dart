import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/presentation/widgets/show_dialog_deposit_screen.dart';
import 'package:intl/intl.dart';

import '../../data/bloc/deposit_bloc/deposit_cubit.dart';
import '../../data/model/deposit_model.dart';
import '../widgets/card_widget.dart';
import '../widgets/diolog_widget.dart';
import '../widgets/switch_widget.dart';

class DepositScreen extends StatefulWidget {
  static String name = 'deposit_screen';
  static String path = '/deposit_screen';
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<DepositReplenishmentsModel> _allDeposits = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalCount = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DepositCubit>().fetchDeposits();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMore) {
      _loadMoreData();
    }
  }

  void _loadMoreData() async {
    if (!mounted ||
        _isLoadingMore ||
        _currentPage >= _totalPages ||
        _allDeposits.length >= _totalCount) {
      return;
    }

    setState(() => _isLoadingMore = true);
    final cubit = context.read<DepositCubit>();
    final nextPage = _currentPage + 1;

    try {
      await cubit.fetchDeposits(page: nextPage);

      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy HH:mm').format(parsedDate);
  }

  Map<String, List<DepositReplenishmentsModel>> groupByDate(
      List<DepositReplenishmentsModel> deposits) {
    Map<String, List<DepositReplenishmentsModel>> grouped = {};
    for (var deposit in deposits) {
      String formattedDate =
          "${deposit.createdAt.day} ${getMonthName(deposit.createdAt.month)}";
      grouped.putIfAbsent(formattedDate, () => []).add(deposit);
    }
    return grouped;
  }

  String getMonthName(int month) {
    const months = [
      "январь",
      "февраль",
      "март",
      "апрель",
      "май",
      "июнь",
      "июль",
      "август",
      "сентябрь",
      "октябрь",
      "ноябрь",
      "декабрь"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: dynamicTheme.appBarBackgroundColor,
        centerTitle: true,
        leading: const SizedBox(),
        toolbarHeight: 40.h,
        title: Text(
          "Выручка",
          style: TextStyle(
            color: dynamicTheme.white,
            fontSize: 18.sp,
            fontFamily: 'Regular',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: dynamicTheme.backgroundColor,
      body: BlocListener<DepositCubit, DepositState>(
        listener: (context, state) {
          if (state is DepositData) {
            setState(() {
              _allDeposits = state.deposits;
              _currentPage = state.currentPage;
              _totalPages = state.pageCount;
              _totalCount = state.totalCount;
            });
          } else if (state is DepositError) {
            print('Xato: ${state.message}');
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _allDeposits.clear();
            setState(() {});
            await context.read<DepositCubit>().fetchDeposits();
          },
          child: _buildBody(dynamicTheme),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeColors dynamicTheme) {
    if (_allDeposits.isEmpty && !_isLoadingMore) {
      return BlocBuilder<DepositCubit, DepositState>(
        builder: (context, state) {
          if (state is DepositLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DepositError) {
            return Center(child: Text('${state.message}'));
          } else if (state is DepositData && _allDeposits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/noData.png',
                      height: 180.h, width: 200.w),
                  SizedBox(height: 10.h),
                  Text(
                    'Нет новых поступлений',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: dynamicTheme.white,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      );
    }

    final groupedEntries = groupByDate(_allDeposits);
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomToggleButton(
            labels: ['В транзите', 'Передано'],
            onToggle: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: groupedEntries.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == groupedEntries.length && _isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final entry = groupedEntries.entries.elementAt(index);
              final filteredDeposits = selectedIndex == 0
                  ? entry.value.where((deposit) => deposit.status == 4).toList()
                  : entry.value
                      .where((deposit) => deposit.status == 2)
                      .toList();

              if (filteredDeposits.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: Text(
                      "  ${entry.key}",
                      style: TextStyle(
                        color: dynamicTheme.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  ...filteredDeposits.map(
                    (deposit) => CardWidget(
                      name: deposit.login,
                      date: formatDate("${deposit.createdAt}"),
                      summa: deposit.amount,
                      onevent: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return Padding(
                              padding: EdgeInsets.only(top: 150.h),
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: const Offset(0, 0),
                                ).animate(animation),
                                child: selectedIndex == 0
                                    ? ShowDialogDepositScreen(
                                        depositId: deposit.id,
                                        login: deposit.login,
                                        statusName: deposit.statusName,
                                        date:
                                            formatDate("${deposit.createdAt}"),
                                        summa: deposit.amount,
                                        comment: deposit.comment,
                                        operatorImage:
                                            "${deposit.operatorPhoto}",
                                      )
                                    : DiologWidget(
                                        depositId: deposit.id,
                                        login: deposit.login,
                                        statusName: deposit.statusName,
                                        date:
                                            formatDate("${deposit.createdAt}"),
                                        summa: deposit.amount,
                                        comment: deposit.comment,
                                        operatorImage:
                                            "${deposit.operatorPhoto}",
                                        courierImage: "${deposit.courierPhoto}",
                                      ),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
