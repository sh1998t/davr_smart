import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:intl/intl.dart';

import '../../data/model/deposit_model.dart';
import '../widgets/card_widget.dart';
import '../widgets/diolog_widget.dart';

class HistoryScreen extends StatefulWidget {
  static String name = 'history_screen';
  static String path = '/history_screen';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DepositCubit>().fetchDeposits();
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
        backgroundColor: dynamicTheme.appBarBackgroundColor,
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
      backgroundColor: dynamicTheme.backgroundColor,
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
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: groupByDate(state.deposits)
                        .entries
                        .where((entry) =>
                            entry.value.any((deposit) => deposit.status == 6))
                        .isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var entry in groupByDate(state.deposits)
                              .entries
                              .where((entry) => entry.value
                                  .any((deposit) => deposit.status == 6))) ...[
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
                                .where((deposit) => deposit.status == 6)
                                .map((deposit) => CardWidget(
                                      name: deposit.login,
                                      date: formatDate("${deposit.createdAt}"),
                                      summa: deposit.amount,
                                      onevent: () {
                                        print(deposit.status);
                                        Scaffold.of(context).showBottomSheet(
                                          (BuildContext context) {
                                            return Container(
                                              height: 500.h,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(35.r),
                                                  topRight:
                                                      Radius.circular(35.r),
                                                  bottomLeft:
                                                      Radius.circular(0.r),
                                                  bottomRight:
                                                      Radius.circular(0.r),
                                                ),
                                              ),
                                              child: DiologWidget(
                                                bankName: deposit.bankName,
                                                courierImage:
                                                    "${deposit.courierPhoto}",
                                                depositId: deposit.id,
                                                login: deposit.login,
                                                statusName: deposit.statusName,
                                                date: formatDate(
                                                    "${deposit.createdAt}"),
                                                summa: deposit.amount,
                                                comment: deposit.comment,
                                                operatorImage:
                                                    "${deposit.operatorPhoto}",
                                              ),
                                            );
                                          },
                                          elevation: 0,
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

// class CardWidget extends StatelessWidget {
//   final String? name;
//   final String? date;
//   final double? summa;
//   const CardWidget(
//       {super.key, required this.date, required this.name, required this.summa});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60.h,
//       width: MediaQuery.of(context).size.width,
//       child: OutlinedButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return ShowDialogWidget();
//             },
//           );
//         },
//         style: OutlinedButton.styleFrom(
//           padding: EdgeInsets.only(left: 10.w, right: 10.w),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           side: BorderSide.none,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   height: 45.h,
//                   width: 50.w,
//                   decoration: BoxDecoration(
//                       color: MainColor.darkTheme.black12,
//                       borderRadius: BorderRadius.circular(5.r)),
//                   child: Center(
//                     child: SvgPicture.asset(
//                       'assets/images/logo.svg',
//                       width: 25,
//                       color: MainColor.darkTheme.white,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     '$name',
//                     style: TextStyle(
//                         fontSize: 16.sp, color: MainColor.darkTheme.white60),
//                   ),
//                   Text(
//                     '$summa',
//                     style: TextStyle(
//                         fontSize: 16.sp, color: MainColor.darkTheme.white),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 110.w,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     '$date',
//                     style: TextStyle(
//                         fontSize: 14.sp, color: MainColor.darkTheme.white60),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
