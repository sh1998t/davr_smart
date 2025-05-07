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
        backgroundColor: Color.fromRGBO(245, 250, 254, 1),
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: dynamicTheme.white),
          backgroundColor: Color(0xFFF5FAFF),
          title: Text(
            'Статистика ',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(1, 2, 6, 1)),
          ),
        ),
        body:
            BlocListener<UserMeCubit, UserMeState>(listener: (context, state) {
          if (state is UserMeData) {
            final userId = state.userMe.id;
            context.read<StatistikaCubit>().data(userId!);
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
                  padding: EdgeInsets.only(left: 26.w, right: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.h,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: (_height == 56) ? 80.h : 100.h,
                            width: 74.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70.r),
                              child: Image.asset(
                                'assets/images/person.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${state.data.courierFullName} ",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color.fromRGBO(1, 2, 6, 1),
                                      fontWeight: FontWeight.w500)),
                              Text(
                                state.data.courierUserName,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(109, 109, 109, 1)),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),

                      ColumnWidgetStatics(
                          text: 'Ид', title: '${state.data.courierId}'),
                      ColumnWidgetStatics(
                          text: 'Регион',
                          title: '${state.data.courierRegionName}'),
                      ColumnWidgetStatics(
                          text: 'Структура',
                          title: '${state.data.courierStructureName}'),
                      ColumnWidgetStatics(
                          text: 'Сумма в транзите',
                          title: '${state.data.totalAcceptedCount}'),
                      ColumnWidgetStatics(
                          text: 'Кол в транзите',
                          title: '${state.data.totalAcceptedAmount}'),
                      ColumnWidgetStatics(
                          text: 'Сумма передана',
                          title: '${state.data.totalWaitingCount}'),
                      //
                      ColumnWidgetStatics(
                          text: 'Кол  переданных сумм',
                          title: '${state.data.totalWaitingAmount}'),
                      ColumnWidgetStatics(
                          text: 'Сумма подтверждённых',
                          title: '${state.data.totalConfirmedCount}'),
                      ColumnWidgetStatics(
                          text: 'Кол подтверждённых',
                          title: '${state.data.totalConfirmedAmount}'),
                      ColumnWidgetStatics(
                          text: 'Инкассатора  Баланс',
                          title: '${state.data.courierBalance}')
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

class ColumnWidgetStatics extends StatefulWidget {
  final String text;
  final String title;

  const ColumnWidgetStatics({
    super.key,
    required this.text,
    required this.title,
  });

  @override
  State<ColumnWidgetStatics> createState() => _ColumnWidgetStaticsState();
}

class _ColumnWidgetStaticsState extends State<ColumnWidgetStatics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.text} :",
          style: TextStyle(
              height: 1.5.h,
              fontSize: 11.sp,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(109, 109, 109, 1)),
        ),
        Text(
          widget.title,
          style: TextStyle(
              height: 0,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, 1)),
        ),
      ],
    );
  }
}
