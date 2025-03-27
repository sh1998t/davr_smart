import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ core/colors.dart';

class ShowDialogHistoryWidget extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? image;
  final String? comment;
  const ShowDialogHistoryWidget({
    required this.depositId,
    required this.login,
    required this.statusName,
    required this.date,
    required this.summa,
    required this.image,
    required this.comment,
    super.key,
  });

  @override
  State<ShowDialogHistoryWidget> createState() => _ShowDialogWidgetState();
}

class _ShowDialogWidgetState extends State<ShowDialogHistoryWidget> {
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
              height: MediaQuery.of(context).size.height - 600,
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
                  left: 30.w,
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
                      "Статус",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.statusName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.summa}",
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
                                'документ',
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
                              color: dynamicTheme.containerBackground),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {},
                              child: Text(
                                'документ',
                                style: TextStyle(
                                    fontSize: 16.sp, color: dynamicTheme.white),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 238.h,
              color: Color(0xff1D1D1D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Имя',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    'Имя Кассир',
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
                    'Имя статуса',
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
                    '12:00 00.00',
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
                    '100000000',
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
