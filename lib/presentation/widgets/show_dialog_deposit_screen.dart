import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
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
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 380.h,
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
                    MainColor.darkTheme.opacityColorsTop,
                    MainColor.darkTheme.opacityColorsButton,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 25.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: MainColor.darkTheme.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Успешно",
                      style: TextStyle(
                          color: MainColor.darkTheme.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Оплата",
                      style: TextStyle(
                          color: MainColor.darkTheme.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$summa",
                      style: TextStyle(
                          color: MainColor.darkTheme.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MainColor.darkTheme.containerBackground),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                side: BorderSide.none,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Отклонение',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: MainColor.darkTheme.white),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MainColor.darkTheme.containerBackground),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                CherryToast.warning(
                                  inheritThemeColors: true,
                                  description: const Text(
                                    'Ошибка',
                                  ),
                                  animationType: AnimationType.fromTop,
                                  action: const Text(
                                      'Резервное копирование данных'),
                                  actionHandler: () {},
                                ).show(context);
                              },
                              child: Text(
                                'Принятие',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: MainColor.darkTheme.white),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 313.h,
              color: MainColor.darkTheme.containerColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Имя',
                    style: TextStyle(
                        fontSize: 14.sp, color: MainColor.darkTheme.white38),
                  ),
                  Text(
                    "$login",
                    style: TextStyle(
                        fontSize: 16.sp, color: MainColor.darkTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Статус ',
                    style: TextStyle(
                        fontSize: 14.sp, color: MainColor.darkTheme.white38),
                  ),
                  Text(
                    '$statusName',
                    style: TextStyle(
                        fontSize: 16.sp, color: MainColor.darkTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'дата ',
                    style: TextStyle(
                        fontSize: 14.sp, color: MainColor.darkTheme.white38),
                  ),
                  Text(
                    '$date',
                    style: TextStyle(
                        fontSize: 16.sp, color: MainColor.darkTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Сумма',
                    style: TextStyle(
                        fontSize: 14.sp, color: MainColor.darkTheme.white38),
                  ),
                  Text(
                    "$summa",
                    style: TextStyle(
                        fontSize: 16.sp, color: MainColor.darkTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'комментария ',
                    style: TextStyle(
                        fontSize: 14.sp, color: MainColor.darkTheme.white38),
                  ),
                  Text(
                    "$comment",
                    style: TextStyle(
                        fontSize: 16.sp, color: MainColor.darkTheme.white),
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
