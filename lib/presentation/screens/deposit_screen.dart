import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/presentation/widgets/pad_widget/pad_dialog_deposit_screen.dart';
import 'package:incasator/presentation/widgets/pad_widget/pad_dialog_submitted_deposit_screen.dart';
import 'package:incasator/presentation/widgets/select_bank.dart';
import 'package:incasator/presentation/widgets/show_dialog_deposit_screen.dart';
import 'package:intl/intl.dart';

import '../../data/bloc/collect_cubit.dart';
import '../../data/bloc/deposit_bloc/deposit_cubit.dart';
import '../../data/model/deposit_model.dart';
import '../widgets/card_widget_status.dart';
import '../widgets/show_dialog_submitted_deposit_screen.dart';
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
  double _height = 56.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getDeviceInfo();
    context.read<DepositCubit>().fetchDeposits();
  }

  Future<void> getDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      if (deviceInfo is AndroidDeviceInfo) {
        print("kfgdskfgks;dfgkls === == ${deviceInfo.data}");
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
        backgroundColor: Color(0xFFF5FAFF),
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
      backgroundColor: Color(0xFFF5FAFF),
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
            setState(() {
              getDeviceInfo();
            });
            await context.read<DepositCubit>().fetchDeposits();
          },
          child: _buildBody(dynamicTheme),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeColors dynamicTheme) {
    final groupedEntries = groupByDate(_allDeposits);

    final hasAnyData = groupedEntries.entries.any((entry) {
      final filtered = selectedIndex == 0
          ? entry.value.where((deposit) => deposit.status == 4)
          : entry.value.where((deposit) => deposit.status == 2);
      return filtered.isNotEmpty;
    });

    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: CustomToggleButton(
            labels: ['В транзите', 'Передано'],
            onToggle: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
        ),
        SizedBox(height: 5.h),
        Expanded(
          child: Builder(
            builder: (context) {
              if (_allDeposits.isEmpty && !_isLoadingMore) {
                return BlocBuilder<DepositCubit, DepositState>(
                  builder: (context, state) {
                    if (state is DepositLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DepositError) {
                      return Center(child: Text('${state.message}'));
                    }
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
                  },
                );
              }

              if (!hasAnyData) {
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

              return ListView.builder(
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
                      ? entry.value
                          .where((deposit) => deposit.status == 4)
                          .toList()
                      : entry.value
                          .where((deposit) => deposit.status == 2)
                          .toList();

                  if (filteredDeposits.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      ...filteredDeposits.map((deposit) {
                        return CardWidgetStatus(
                            height: _height,
                            color: (deposit.status == 2)
                                ? Color(0xFF1A237E)
                                : Color(0xFF572DA6),
                            name: deposit.login,
                            date: formatDate("${deposit.createdAt}"),
                            summa: deposit.amount,
                            onevent: () {
                              context.read<CollectCubit>().clear();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return (_height == 56)
                                      ? Container(
                                          // (widget.courierPhoto != null) ? 340.h : 300.h,
                                          height: (deposit.courierPhoto != null)
                                              ? 575.h
                                              : 600.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor, // yoki dynamicTheme.backgroundColor
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(35.r),
                                              topRight: Radius.circular(35.r),
                                            ),
                                          ),
                                          child: selectedIndex == 0
                                              ? ShowDialogDepositScreen(
                                                  selectBank: SelectBank(),
                                                  depositId: deposit.id,
                                                  login: deposit.login,
                                                  statusName:
                                                      deposit.statusName,
                                                  date: formatDate(
                                                      "${deposit.createdAt}"),
                                                  summa: deposit.amount,
                                                  comment: deposit.comment,
                                                  operatorImage:
                                                      "${deposit.operatorPhoto}",
                                                )
                                              : ShowDialogSubmittedDepositScreen(
                                                  depositId: deposit.id,
                                                  login: deposit.login,
                                                  statusName:
                                                      deposit.statusName,
                                                  date: formatDate(
                                                      "${deposit.createdAt}"),
                                                  summa: deposit.amount,
                                                  comment: deposit.comment,
                                                  operatorImage:
                                                      "${deposit.operatorPhoto}",
                                                  bankName: deposit.bankName,
                                                  courierPhoto:
                                                      deposit.courierPhoto,
                                                ),
                                        )
                                      : Container(
                                          height: (deposit.courierPhoto != null)
                                              ? 590.h
                                              : 600.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor, // yoki dynamicTheme.backgroundColor
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(35.r),
                                              topRight: Radius.circular(35.r),
                                            ),
                                          ),
                                          child: selectedIndex == 0
                                              ? PadDialogDepositScreen(
                                                  selectBank: SelectBank(),
                                                  depositId: deposit.id,
                                                  login: deposit.login,
                                                  statusName:
                                                      deposit.statusName,
                                                  date: formatDate(
                                                      "${deposit.createdAt}"),
                                                  summa: deposit.amount,
                                                  comment: deposit.comment,
                                                  operatorImage:
                                                      "${deposit.operatorPhoto}",
                                                )
                                              : PadDialogSubmittedDepositScreen(
                                                  depositId: deposit.id,
                                                  login: deposit.login,
                                                  statusName:
                                                      deposit.statusName,
                                                  date: formatDate(
                                                      "${deposit.createdAt}"),
                                                  summa: deposit.amount,
                                                  comment: deposit.comment,
                                                  operatorImage:
                                                      "${deposit.operatorPhoto}",
                                                  bankName: deposit.bankName,
                                                  courierPhoto:
                                                      deposit.courierPhoto,
                                                ),
                                        );
                                },
                              );
                            },
                            statusName: (deposit.status == 2)
                                ? 'Передано'
                                : deposit.statusName);
                      }),
                      SizedBox(height: 10.h),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
