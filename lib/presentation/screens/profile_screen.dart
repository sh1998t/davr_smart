import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/bloc/statistika_bloc/statistika__cubit.dart';

import '../../ core/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StatistikaCubit>().data();
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
        backgroundColor: Color(0xFF323747),
        appBar: AppBar(
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF323747),
          leading: Text(''),
          title: Text(
            'Статистика',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<StatistikaCubit, StatistikaState>(
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
              print("Error +++++ ==== = = ==${state.error}");
              return Center(
                child: Text('${state.error}'),
              );
            } else if (state is StatistikaData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      color: Color(0xFF323747),
                      height: 100.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 50.h,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Color(0xFFEDEEF0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.person,
                              size: 45,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("${state.data.courierFullName} ",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 5.h),
                              Text(
                                state.data.courierUserName,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25)),
                            color: Color(0xFF13171F)),
                        height: MediaQuery.of(context).size.height - 238.2,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('courierId',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.courierId}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('courierRegionName',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.courierRegionName,
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('courierStructureName',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.courierStructureName}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalAcceptedCount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalAcceptedCount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalAcceptedAmount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalAcceptedAmount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalWaitingCount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalWaitingCount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalWaitingAmount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalWaitingAmount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalConfirmedCount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalConfirmedCount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('totalConfirmedAmount',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.totalConfirmedAmount}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('fromDateTime',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.fromDateTime,
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('toDateTime',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.toDateTime,
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('courierBalance',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${state.data.courierBalance}",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                Text('courierLastDepositDate',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  state.data.courierLastDepositDate,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        ))
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
