import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/presentation/widgets/pad_widget/pad_card_widget.dart';
import 'package:incasator/presentation/widgets/pad_widget/pad_dialog_precessing_screen.dart';
import 'package:intl/intl.dart';

import '../../data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import '../../data/model/deposit_model.dart';
import '../widgets/card_widget.dart';
import '../widgets/widget_dialog.dart';

class PrecessingScreen extends StatefulWidget {
  static String name = 'precessing_screen';
  static String path = '/precessing_screen';
  const PrecessingScreen({super.key});

  @override
  State<PrecessingScreen> createState() => _PrecessingScreenState();
}

class _PrecessingScreenState extends State<PrecessingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<DepositReplenishmentsModel> _allDeposits = [];
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalCount = 0;
  double _height = 56.0;
  double _height1 = 40.w;
  double _width = 40.w;
  double _width1 = 20;
  Future<void> getDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      if (deviceInfo is AndroidDeviceInfo) {
        setState(() {
          _height =
              deviceInfo.model.toLowerCase().contains('pad') ? 66.0 : 56.0;
          _height1 =
              deviceInfo.model.toLowerCase().contains('pad') ? 30.h : 40.h;
          _width = deviceInfo.model.toLowerCase().contains('pad') ? 50.w : 40.w;
          _width1 =
              deviceInfo.model.toLowerCase().contains('pad') ? 25.0 : 20.0;
        });
      }
    } catch (e) {
      print("Xato: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    _scrollController.addListener(_onScroll);
    context.read<ProcessingCubit>().fetchProcessing();
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
    final cubit = context.read<ProcessingCubit>();
    final nextPage = _currentPage + 1;
    try {
      await cubit.fetchProcessing(page: nextPage);
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      print('Xato: $e');
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
    return DateFormat('HH:mm').format(parsedDate);
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.h),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications,
                  size: 28, color: dynamicTheme.white),
            ),
          ),
        ],
        title: Text(
          "Поступление",
          style: TextStyle(
            color: dynamicTheme.white,
            fontSize: 18.sp,
            fontFamily: 'Regular',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5FAFF),
      body: BlocListener<ProcessingCubit, ProcessingState>(
        listener: (context, state) {
          if (state is ProcessingLoaded) {
            setState(() {
              _allDeposits = List<DepositReplenishmentsModel>.from(
                  state.replenishmentList['items']);
              _currentPage = state.currentPage;
              _totalPages = state.replenishmentList['pageCount'] as int;
              _totalCount = state.replenishmentList['totalCount'] as int;
            });
          } else if (state is ProcessingError) {
            print('Xato: ${state.message}');
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _allDeposits.clear();
            setState(() {});
            await context.read<ProcessingCubit>().fetchProcessing();
          },
          child: _buildBody(dynamicTheme),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeColors dynamicTheme) {
    if (_allDeposits.isEmpty && !_isLoadingMore) {
      return BlocBuilder<ProcessingCubit, ProcessingState>(
        builder: (context, state) {
          if (state is ProcessingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProcessingError) {
            return Center(child: Text('${state.message}'));
          } else if (state is ProcessingLoaded && _allDeposits.isEmpty) {
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
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groupedEntries.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groupedEntries.length && _isLoadingMore) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = groupedEntries.entries.elementAt(index);
        return Column(
          spacing: 0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: Text(
                "  ${entry.key}",
                style: TextStyle(
                  color: dynamicTheme.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...entry.value.map(
              (deposit) => (_height == 56)
                  ? CardWidget(
                      height1: _height1,
                      width: _width,
                      width1: _width1,
                      height: _height,
                      name: deposit.login,
                      date: formatDate("${deposit.createdAt}"),
                      summa: deposit.amount,
                      onevent: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return (_height == 56)
                                ? Container(
                                    height: 550.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.r),
                                        topRight: Radius.circular(24.r),
                                      ),
                                    ),
                                    child: WidgetDialog(
                                      depositId: deposit.id,
                                      login: deposit.login,
                                      statusName: deposit.statusName,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      comment: deposit.comment,
                                      image: deposit.operatorPhoto,
                                    ),
                                  )
                                : Container(
                                    height: 530.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.r),
                                        topRight: Radius.circular(24.r),
                                      ),
                                    ),
                                    child: PadDialogPrecessingScreen(
                                      depositId: deposit.id,
                                      login: deposit.login,
                                      statusName: deposit.statusName,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      comment: deposit.comment,
                                      image: deposit.operatorPhoto,
                                    ),
                                  );
                          },
                        );
                      },
                    )
                  : PadCardWidget(
                      height1: _height1,
                      width: _width,
                      width1: _width1,
                      height: _height,
                      name: deposit.login,
                      date: formatDate("${deposit.createdAt}"),
                      summa: deposit.amount,
                      onevent: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return (_height == 56)
                                ? Container(
                                    height: 600.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.r),
                                        topRight: Radius.circular(24.r),
                                      ),
                                    ),
                                    child: WidgetDialog(
                                      depositId: deposit.id,
                                      login: deposit.login,
                                      statusName: deposit.statusName,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      comment: deposit.comment,
                                      image: deposit.operatorPhoto,
                                    ),
                                  )
                                : Container(
                                    height: 500.h,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.r),
                                        topRight: Radius.circular(24.r),
                                      ),
                                    ),
                                    child: PadDialogPrecessingScreen(
                                      depositId: deposit.id,
                                      login: deposit.login,
                                      statusName: deposit.statusName,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      comment: deposit.comment,
                                      image: deposit.operatorPhoto,
                                    ),
                                  );
                          },
                        );
                      },
                    ),
            ),
            SizedBox(height: 0.h),
          ],
        );
      },
    );
  }
}
