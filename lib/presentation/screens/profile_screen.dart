import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/bloc/userme/user_me_cubit.dart';
import 'package:incasator/presentation/screens/statics.dart';

import '../../ core/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            ' Профиль',
            style: TextStyle(
              color: dynamicTheme.white,
            ),
          ),
          backgroundColor: Color(0xFFF5FAFF),
          actions: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: IconButton(
                  onPressed: () {
                    // AdaptiveTheme.of(context).toggleThemeMode();
                  },
                  icon: Icon(
                    Icons.dark_mode,
                    size: 28,
                    color: dynamicTheme.white,
                  )),
            )
          ],
        ),
        body: BlocBuilder<UserMeCubit, UserMeState>(
          builder: (context, state) {
            if (state is UserMeLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserMeError) {
              print(state.message);
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: dynamicTheme.white),
                ),
              );
            } else if (state is UserMeData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: SizedBox(
                        height: (_height == 56) ? 80.h : 110.h,
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
                      "${state.userMe.login}",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: dynamicTheme.white,
                      ),
                    ),
                    Text(
                      "${state.userMe.code}",
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
                                  InkWell(
                                    child: SizedBox(
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
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StaticsScreen(),
                                          ));
                                    },
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
                                        // Text(
                                        //   "${state.data.courierBalance}   ",
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.w600,
                                        //       fontSize: 14.sp,
                                        //       color:
                                        //           (state.data.courierBalance >
                                        //                   0)
                                        //               ? dynamicTheme.white
                                        //               : Colors.red),
                                        // )
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
                          child: InkWell(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Container(
                                    height: 235.h,
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w, top: 6.h),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: dynamicTheme.black,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16.r),
                                            topLeft: Radius.circular(16.r))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Выход',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: dynamicTheme.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'Вы действительно хотите выйти из своей',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'учетной записи?',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFF7A1DFF),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.r)),
                                            height: 45.h,
                                            width: 343.w,
                                            child: Center(
                                              child: Text(
                                                'Подтвердеть',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontSize: 17.sp,
                                                      color: dynamicTheme.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFECEff0),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.r)),
                                            height: 45.h,
                                            width: 343.w,
                                            child: Center(
                                              child: Text(
                                                'Отмена ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontSize: 17.sp,
                                                      color: dynamicTheme.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
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
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: dynamicTheme.white,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
