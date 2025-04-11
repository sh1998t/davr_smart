import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ core/colors.dart';
import '../../data/bloc/statistika_bloc/statistika__cubit.dart';
import '../../data/bloc/userme/user_me_cubit.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({super.key});

  @override
  State<StaticsScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<StaticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserMeCubit>().fetchUserMe();
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
        backgroundColor: Color(0xFFF5FAFF),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: dynamicTheme.white),
          backgroundColor: Color(0xFFF5FAFF),
          title: Text(
            'Статистика',
            style: TextStyle(color: dynamicTheme.white),
          ),
        ),
        body:
            BlocListener<UserMeCubit, UserMeState>(listener: (context, state) {
          if (state is UserMeLoaded) {
            final userId = state.userMe.id;
            context.read<StatistikaCubit>().data(userId);
          }
        }, child: BlocBuilder<StatistikaCubit, StatistikaState>(
          builder: (context, state) {
            if (state is StatistikaLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StatistikaData && state.data == null) {
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
            } else if (state is StatistikaError) {
              return Center(
                child: Text(
                  '${state.error}',
                  style: TextStyle(color: dynamicTheme.white),
                ),
              );
            } else if (state is StatistikaData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 80.h,
                              width: 80.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: Image.asset(
                                  'assets/images/person.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text("${state.data.courierFullName} ",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: dynamicTheme.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            state.data.courierUserName,
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: dynamicTheme.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.only(top: 30, left: 20.w, right: 20.w),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5FAFF),
                        ),
                        height: MediaQuery.of(context).size.height - 238.2,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Ид',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.courierId}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Регион',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.courierRegionName,
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Структура',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.courierStructureName,
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Сумма в транзите ',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalAcceptedCount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Кол в транзите ',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalAcceptedAmount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Сумма передана',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalWaitingCount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Кол  переданных сумм',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalWaitingAmount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Сумма подтверждённых',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalConfirmedCount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Кол подтверждённых',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalConfirmedAmount}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Инкассатора  Баланс',
                                    style: TextStyle(
                                        color: dynamicTheme.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.courierBalance}",
                                  style: TextStyle(
                                      color: dynamicTheme.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ))
                  ],
                ),
              );
            }

            return Container();
          },
        )));
  }
}
