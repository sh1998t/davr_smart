import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:incasator/data/bloc/statistika_bloc/statistika__cubit.dart';
import 'package:incasator/presentation/screens/statics.dart';

import '../../ core/api_const.dart';
import '../../ core/colors.dart';
import '../../data/bloc/userme/user_me_cubit.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        backgroundColor: dynamicTheme.backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            ' Профиль',
            style: TextStyle(
              color: dynamicTheme.white,
            ),
          ),
          backgroundColor: dynamicTheme.appBarBackgroundColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: IconButton(
                  onPressed: () {
                    AdaptiveTheme.of(context).toggleThemeMode();
                  },
                  icon: Icon(
                    Icons.dark_mode,
                    size: 28,
                    color: dynamicTheme.white,
                  )),
            )
          ],
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
                      height: 10.h,
                    ),
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
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      state.data.courierUserName,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: dynamicTheme.white,
                      ),
                    ),
                    Text(
                      "${state.data.courierCode}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: dynamicTheme.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Card(
                        color: dynamicTheme.CardColor,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              padding: EdgeInsets.only(
                                  left: 10.w, right: 10.w, top: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 20.sp,
                                              color: dynamicTheme.white,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Профиль',
                                              style: TextStyle(
                                                  color: dynamicTheme.white),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Divider(
                                      color: dynamicTheme.black12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.map,
                                              size: 20.sp,
                                              color: dynamicTheme.white,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Карта',
                                              style: TextStyle(
                                                  color: dynamicTheme.white),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Divider(
                                      color: dynamicTheme.black12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                              size: 20.sp,
                                              color: dynamicTheme.white,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Уведомления',
                                              style: TextStyle(
                                                  color: dynamicTheme.white),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Card(
                        color: dynamicTheme.CardColor,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              padding: EdgeInsets.only(
                                  left: 10.w, right: 10.w, top: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.bar_chart_rounded,
                                                size: 20,
                                                color: dynamicTheme.white),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Статистика',
                                              style: TextStyle(
                                                  color: dynamicTheme.white),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StaticsScreen(),
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Divider(
                                      color: dynamicTheme.black12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: dynamicTheme.white,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text('Баланс',
                                                style: TextStyle(
                                                  color: dynamicTheme.white,
                                                )),
                                          ],
                                        ),
                                        Text(
                                          "${state.data.courierBalance}   ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                              color:
                                                  (state.data.courierBalance >
                                                          0)
                                                      ? dynamicTheme.white
                                                      : Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Card(
                        color: dynamicTheme.CardColor,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(
                                  left: 10.w, right: 10.w, top: 5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.support,
                                              color: dynamicTheme.white,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Поддержка',
                                              style: TextStyle(
                                                  color: dynamicTheme.white),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Card(
                        color: dynamicTheme.CardColor,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              padding: EdgeInsets.only(
                                  left: 10.w, right: 10.w, top: 8),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              'Выйти',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              const storage =
                                                  FlutterSecureStorage();
                                              await storage.delete(
                                                  key: ApiConst.token);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: dynamicTheme.white,
                                              size: 18,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        )));
  }
}
