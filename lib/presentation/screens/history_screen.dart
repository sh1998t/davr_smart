import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:incasator/presentation/widgets/pad_widget/pad_dialog_historiy_screen.dart';
import 'package:intl/intl.dart';

import '../../data/model/deposit_model.dart';
import '../widgets/card_widget_status.dart';
import '../widgets/diolog_widget.dart';

class HistoryScreen extends StatefulWidget {
  static String name = 'history_screen';
  static String path = '/history_screen';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoadingMore = false;
  List<DepositReplenishmentsModel> _allDeposits = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalCount = 0;
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  double _height = 56.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<DepositCubit>().fetchDeposits();
    getDeviceInfo();
  }

  Future<void> getDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      if (deviceInfo is AndroidDeviceInfo) {
        setState(() {
          _height =
              deviceInfo.model.toLowerCase().contains('pad') ? 66.0 : 56.0;
        });
      }
    } catch (e) {
      print("Xato: $e");
    }
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
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5FAFF),
        centerTitle: true,
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "История",
          style: TextStyle(
              color: dynamicTheme.white,
              fontSize: 18.sp,
              fontFamily: 'Regular',
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Color(0xFFF5FAFF),
      body: BlocBuilder<DepositCubit, DepositState>(
        builder: (context, state) {
          if (state is DepositLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DepositError) {
            print(state.message);
            return Center(
              child: Text('${state.message}'),
            );
          } else if (state is DepositData && state.deposits.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/noData.png',
                    height: 180.h,
                    width: 200.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Нет новых поступлений',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: dynamicTheme.white))
                ],
              ),
            );
          } else if (state is DepositData) {
            _allDeposits.addAll(state.deposits);
            _currentPage = state.currentPage;
            _totalPages = state.pageCount;
            _totalCount = state.totalCount;

            return RefreshIndicator(
              onRefresh: () async {
                _allDeposits.clear();
                setState(() {});
                await context.read<DepositCubit>().fetchDeposits();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: groupByDate(state.deposits)
                          .entries
                          .where((entry) => entry.value.any((deposit) =>
                              deposit.status == 6 || deposit.status == -1))
                          .isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var entry in groupByDate(state.deposits)
                                .entries
                                .where((entry) => entry.value.any((deposit) =>
                                    deposit.status == 6 ||
                                    deposit.status == -1))) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 12.w),
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
                              ...entry.value
                                  .where((deposit) =>
                                      deposit.status == 6 ||
                                      deposit.status == -1)
                                  .map((deposit) => CardWidgetStatus(
                                        height: _height,
                                        statusName: deposit.statusName,
                                        color: (deposit.status == -1)
                                            ? Color(0xFFe55353)
                                            : Color(0xFF00bf63),
                                        name: deposit.login,
                                        date:
                                            formatDate("${deposit.createdAt}"),
                                        summa: deposit.amount,
                                        onevent: () {
                                          print(deposit.status);
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled:
                                                true, // Agar kontent uzun bo'lsa, pastga siljishi mumkin bo'ladi
                                            backgroundColor: Colors
                                                .transparent, // Transparan fon
                                            builder: (BuildContext context) {
                                              return (_height == 56)
                                                  ? Container(
                                                      height: 560.h,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  35.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  35.r),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.r),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  0.r),
                                                        ),
                                                      ),
                                                      child: DiologWidget(
                                                        bankName:
                                                            deposit.bankName,
                                                        courierImage:
                                                            "${deposit.courierPhoto}",
                                                        depositId: deposit.id,
                                                        login: deposit.login,
                                                        statusName:
                                                            deposit.statusName,
                                                        date: formatDate(
                                                            "${deposit.createdAt}"),
                                                        summa: deposit.amount,
                                                        comment:
                                                            deposit.comment,
                                                        operatorImage:
                                                            "${deposit.operatorPhoto}",
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 580.h,
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .scaffoldBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  35.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  35.r),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.r),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  0.r),
                                                        ),
                                                      ),
                                                      child:
                                                          PadDialogHistoriyScreen(
                                                        bankName:
                                                            deposit.bankName,
                                                        courierImage:
                                                            "${deposit.courierPhoto}",
                                                        depositId: deposit.id,
                                                        login: deposit.login,
                                                        statusName:
                                                            deposit.statusName,
                                                        date: formatDate(
                                                            "${deposit.createdAt}"),
                                                        summa: deposit.amount,
                                                        comment:
                                                            deposit.comment,
                                                        operatorImage:
                                                            "${deposit.operatorPhoto}",
                                                      ),
                                                    );
                                            },
                                          );
                                        },
                                      )),
                            ]
                          ],
                        )
                      : Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 100.h,
                              ),
                              Image.asset(
                                'assets/images/noData.png',
                                height: 180.h,
                                width: 200.w,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
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
                        ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
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
}
