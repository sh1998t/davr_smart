import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
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
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    context.read<PrecessingBlocCubit>().fetchDeposits(page: 1);
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy HH:mm').format(parsedDate);
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
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: IconButton(
                onPressed: () {
                  AdaptiveTheme.of(context).toggleThemeMode();
                },
                icon: Icon(
                  Icons.notifications,
                  size: 28,
                  color: dynamicTheme.white,
                )),
          )
        ],
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "Обработка поступления",
          style: TextStyle(
              color: dynamicTheme.white,
              fontSize: 18.sp,
              fontFamily: 'Regular',
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: dynamicTheme.backgroundColor,
      body: BlocBuilder<PrecessingBlocCubit, PrecessingBlocState>(
        builder: (context, state) {
          if (state is PrecessingLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PrecessingError) {
            return Center(
              child: Text('${state.message}'),
            );
          } else if (state is PrecessingData && state.deposits.isEmpty) {
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
          } else if (state is PrecessingData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var entry in groupByDate(state.deposits).entries) ...[
                      Text(
                        "  ${entry.key}",
                        style: TextStyle(
                          color: dynamicTheme.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      ...entry.value.map((deposit) => CardWidget(
                            name: deposit.login,
                            date: formatDate("${deposit.createdAt}"),
                            summa: deposit.amount,
                            onevent: () {
                              showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(0, 1),
                                      end: Offset(0, 0),
                                    ).animate(animation),
                                    child: WidgetDialog(
                                      depositId: deposit.id,
                                      login: deposit.login,
                                      statusName: deposit.statusName,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      comment: deposit.comment,
                                      image: Image.network(
                                          "${deposit.operatorPhoto}"),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 300),
                              );
                            },
                          )),
                      SizedBox(height: 10.h),
                    ]
                  ],
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
