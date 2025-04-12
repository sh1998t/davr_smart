import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  double _height = 56.0;
  @override
  void initState() {
    super.initState();
    context.read<UserMeCubit>().fetchUserMe();
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
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          height: (_height == 56) ? 80.h : 110.h,
                          width: 80.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.asset(
                              'assets/images/person.png',
                              fit: BoxFit.fill,
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
                      SizedBox(height: 15.h),
                      Card(
                        color: Colors.white,
                        child: Container(
                          height: (_height == 56) ? 465.h : 525.h,
                          width: MediaQuery.of(context).size.width - 32.w,
                          padding: EdgeInsets.only(left: 12.w, right: 12.w),
                          child: Column(
                            spacing: 5.h,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.perm_identity,
                                  text: 'Ид',
                                  title: '${state.data.courierId}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.public,
                                  text: 'Регион',
                                  title: '${state.data.courierRegionName}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.account_tree,
                                  text: 'Структура',
                                  title: '${state.data.courierStructureName}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.bar_chart,
                                  text: 'Сумма в транзите',
                                  title: '${state.data.totalAcceptedCount}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.account_balance_wallet,
                                  text: 'Кол в транзите',
                                  title: '${state.data.totalAcceptedAmount}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.hourglass_bottom,
                                  text: 'Сумма передана',
                                  title: '${state.data.totalWaitingCount}'),
                              //
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.attach_money,
                                  text: 'Кол  переданных сумм',
                                  title: '${state.data.totalWaitingAmount}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.add_circle,
                                  text: 'Сумма подтверждённых',
                                  title: '${state.data.totalConfirmedCount}'),
                              RowWidgetStatics(
                                  height: _height,
                                  iconData: Icons.check_circle,
                                  text: 'Кол подтверждённых',
                                  title: '${state.data.totalConfirmedAmount}'),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text('Инкассатора  Баланс',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Text(
                                    '${state.data.courierBalance}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Container();
          },
        )));
  }
}

class RowWidgetStatics extends StatefulWidget {
  final String text;
  final String title;
  final IconData? iconData;
  final double height;
  const RowWidgetStatics(
      {super.key,
      required this.text,
      required this.title,
      required this.height,
      required this.iconData});

  @override
  State<RowWidgetStatics> createState() => _RowWidgetStaticsState();
}

class _RowWidgetStaticsState extends State<RowWidgetStatics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  widget.iconData,
                  size: 18,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(widget.text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            Text(
              widget.title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: (widget.height == 56) ? 18.sp : 15.sp,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        Divider(
          color: Colors.black45,
        ),
      ],
    );
  }
}
