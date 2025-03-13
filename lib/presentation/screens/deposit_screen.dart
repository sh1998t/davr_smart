import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/presentation/widgets/show_dialog_deposit_screen.dart';
import 'package:intl/intl.dart';

import '../../data/bloc/deposit_bloc/deposit_cubit.dart';
import '../../data/model/deposit_model.dart';
import '../widgets/card_widget.dart';
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
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor.darkTheme.appBarBackgroundColor,
        centerTitle: true,
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "Выручка",
          style: TextStyle(
              color: MainColor.darkTheme.white,
              fontSize: 18.sp,
              fontFamily: 'Regular',
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Color(0xFF25364A),
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
                          color: MainColor.darkTheme.white))
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
                      labels: ['На руках', 'Передано'],
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
                            children: [
                              for (var entry
                                  in groupByDate(state.deposits).entries) ...[
                                Text(
                                  "  ${entry.key}",
                                  style: TextStyle(
                                    color: MainColor.darkTheme.white,
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
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return SlideTransition(
                                              position: Tween<Offset>(
                                                begin: Offset(0, 1),
                                                end: Offset(0, 0),
                                              ).animate(animation),
                                              child: ShowDialogDepositScreen(
                                                depositId: deposit.id,
                                                login: deposit.login,
                                                statusName: deposit.statusName,
                                                date: formatDate(
                                                    "${deposit.createdAt}"),
                                                summa: deposit.amount,
                                                comment: deposit.comment,
                                                image: Image.network(
                                                    "${deposit.operatorPhoto}"),
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
                                    color: MainColor.darkTheme.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ...entry.value
                                    .where((deposit) => deposit.status == 4)
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
                                                return SlideTransition(
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

// class CardWidget extends StatelessWidget {
//   final String? name;
//   final String? date;
//   final double? summa;
//   final VoidCallback onevent;
//   const CardWidget(
//       {super.key,
//       required this.date,
//       required this.name,
//       required this.summa,
//       required this.onevent});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 60.h,
//       width: MediaQuery.of(context).size.width,
//       child: OutlinedButton(
//         onPressed: onevent,
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
