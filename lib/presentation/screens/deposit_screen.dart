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
  @override
  void initState() {
    super.initState();
    context.read<DepositCubit>().fetchDeposits(page: 1);
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy HH:mm').format(parsedDate);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dynamicTheme.appBarBackgroundColor,
        centerTitle: true,
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "Выручка",
          style: TextStyle(
              color: dynamicTheme.white,
              fontSize: 18.sp,
              fontFamily: 'Regular',
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: dynamicTheme.backgroundColor,
      body: BlocBuilder<DepositCubit, DepositState>(
        builder: (context, state) {
          if (state is DepositLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DepositError) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
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
                  selectedIndex == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var entry
                                  in groupByDate(state.deposits).entries) ...[
                                Text(
                                  "  ${entry.key}",
                                  style: TextStyle(
                                    color: dynamicTheme.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ...entry.value
                                    .where((deposit) => deposit.status == 3)
                                    .map((deposit) => CardWidget(
                                          name: deposit.login,
                                          date: formatDate(
                                              "${deposit.createdAt}"),
                                          summa: deposit.amount,
                                          onevent: () {
                                            showGeneralDialog(
                                              context: context,
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset(0, 1),
                                                      end: Offset(0, 0),
                                                    ).animate(animation),
                                                    child:
                                                        ShowDialogDepositScreen(
                                                      depositId: deposit.id,
                                                      login: deposit.login,
                                                      statusName:
                                                          deposit.statusName,
                                                      date: formatDate(
                                                          "${deposit.createdAt}"),
                                                      summa: deposit.amount,
                                                      comment: deposit.comment,
                                                      image: Image.network(
                                                          "${deposit.operatorPhoto}"),
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 300),
                                            );
                                          },
                                        )),
                              ]
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var entry
                                  in groupByDate(state.deposits).entries) ...[
                                Text(
                                  "  ${entry.key}",
                                  style: TextStyle(
                                    color: dynamicTheme.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ...entry.value
                                    .where((deposit) => deposit.status == 1)
                                    .map((deposit) => CardWidget(
                                          name: deposit.login,
                                          date: formatDate(
                                              "${deposit.createdAt}"),
                                          summa: deposit.amount,
                                          onevent: () {
                                            showGeneralDialog(
                                              context: context,
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: Offset(0, 1),
                                                      end: Offset(0, 0),
                                                    ).animate(animation),
                                                    child: DiologWidget(
                                                      depositId: deposit.id,
                                                      login: deposit.login,
                                                      statusName:
                                                          deposit.statusName,
                                                      date: formatDate(
                                                          "${deposit.createdAt}"),
                                                      summa: deposit.amount,
                                                      comment: deposit.comment,
                                                      image: Image.network(
                                                          "${deposit.operatorPhoto}"),
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 300),
                                            );
                                          },
                                        )),
                              ]
                            ],
                          ),
                        )
                ],
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
