import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';

class ShowDialogDepositScreen extends StatelessWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? image;
  final String? comment;
  const ShowDialogDepositScreen(
      {super.key,
      required this.depositId,
      required this.login,
      required this.statusName,
      required this.date,
      required this.summa,
      required this.image,
      required this.comment});

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 445.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    dynamicTheme.color303030,
                    dynamicTheme.color202020,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: dynamicTheme.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Статус ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: dynamicTheme.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$statusName',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: dynamicTheme.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$summa",
                      style: TextStyle(
                          color: dynamicTheme.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 35.h,
                          width: 140.w,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: dynamicTheme.containerBackground),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                // CourierAcceptDeposit()
                                //     .request("$depositId")
                                //     .then(
                                //       (value) async {
                                //     if (value == true) {
                                //       CherryToast.success(
                                //         animationDuration:
                                //         Duration(milliseconds: 300),
                                //         inheritThemeColors: true,
                                //         animationType: AnimationType.fromTop,
                                //         title: Text('Успех!'),
                                //         description:
                                //         Text('Данные успешно загружены!'),
                                //       ).show(context);
                                //
                                //       await context
                                //           .read<PrecessingBlocCubit>()
                                //           .fetchDeposits();
                                //       Navigator.pop(context);
                                //     } else {
                                //       CherryToast.warning(
                                //         inheritThemeColors: true,
                                //         description: const Text(
                                //           'Ошибка',
                                //         ),
                                //         animationType: AnimationType.fromTop,
                                //         action: const Text(
                                //             'Резервное копирование данных'),
                                //         actionHandler: () {},
                                //       ).show(context);
                                //     }
                                //   },
                                // );
                              },
                              child: Text(
                                'Принять',
                                style: TextStyle(
                                    fontSize: 16.sp, color: dynamicTheme.white),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 250.h,
              color: dynamicTheme.containerColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'логин',
                    style:
                        TextStyle(fontSize: 18.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    '$login',
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'дата ',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    '$date',
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Сумма',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    "$summa",
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'комментария ',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    "$comment",
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
