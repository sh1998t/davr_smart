import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import '../../data/network/courier_accept_deposit.dart';

class PrecessingWidgetDialog extends StatelessWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? image;
  final String? comment;
  const PrecessingWidgetDialog(
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
                    Color(0xFF303030),
                    Color(0xFF202020),
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
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Успешно",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Оплата",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$summa",
                      style: TextStyle(
                          color: Colors.white,
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
                              color: Color(0xFF0F0F0F)),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                side: BorderSide.none,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Отклонение',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
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
                              color: Color(0xFF0F0F0F)),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                CourierAcceptDeposit()
                                    .request("$depositId")
                                    .then(
                                  (value) async {
                                    if (value == true) {
                                      CherryToast.success(
                                        animationDuration:
                                            Duration(milliseconds: 300),
                                        inheritThemeColors: true,
                                        animationType: AnimationType.fromTop,
                                        title: Text('Успех!'),
                                        description:
                                            Text('Данные успешно загружены!'),
                                      ).show(context);

                                      await context
                                          .read<PrecessingBlocCubit>()
                                          .fetchDeposits();
                                      Navigator.pop(context);
                                    } else {
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
                                    }
                                  },
                                );
                              },
                              child: Text(
                                'Принятие',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Card(
                        child: SizedBox(
                          height: 80.h,
                          width: 100.w,
                          child: image,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 313.h,
              color: Color(0xff1D1D1D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'логин',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    '$login',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Статус ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    '$statusName',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'дата ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    '$date',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Сумма',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    "$summa",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'комментария ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    "$comment",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
