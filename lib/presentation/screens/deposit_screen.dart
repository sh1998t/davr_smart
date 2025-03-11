import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:incasator/presentation/widgets/show_dialog_deposit_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../data/bloc/deposit_bloc/deposit_cubit.dart';
import '../../data/model/deposit_model.dart';

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

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B2A),
        centerTitle: true,
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "Выручка",
          style: TextStyle(
              color: Colors.white,
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
              child: Text('Malumot Yo\'q'),
            );
          } else if (state is DepositData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ToggleSwitch(
                      initialLabelIndex: 0,
                      activeFgColor: Color(0xF6750A4),
                      inactiveBgColor: Color(0xFF17222F),
                      minWidth: 620.w,
                      minHeight: 40.h,
                      totalSwitches: 2,
                      labels: ['На руках', 'Передано'],
                      onToggle: (index) {
                        setState(() {
                          selectedIndex = index!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                ...entry.value.map((deposit) => CardWidget(
                                      name: deposit.login,
                                      date: formatDate(deposit.createdAt),
                                      summa: deposit.amount,
                                    )),
                                SizedBox(height: 10.h),
                              ]
                            ],
                          ),
                        )
                      : Text('data'),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  String formatDate(DateTime date) {
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

    return "${date.day} ${months[date.month - 1]} ${date.year}";
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

class InHand extends StatelessWidget {
  const InHand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CardWidget extends StatelessWidget {
  final String? name;
  final String? date;
  final double? summa;
  const CardWidget(
      {super.key, required this.date, required this.name, required this.summa});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ShowDialogDepositScreen();
            },
          );
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 45.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white60),
                  ),
                  Text(
                    '$summa',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                width: 110.w,
              ),
              Column(
                children: [
                  Text(
                    '$date',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white60),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
