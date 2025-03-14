import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../ core/colors.dart';

class CardWidget extends StatelessWidget {
  final String? name;
  final String? date;
  final double? summa;
  final VoidCallback onevent;
  const CardWidget(
      {super.key,
      required this.date,
      required this.name,
      required this.summa,
      required this.onevent});

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return SizedBox(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: onevent,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Center(
                    child: Container(
                      height: 45.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: MainColor.darkTheme.black12,
                          borderRadius: BorderRadius.circular(5.r)),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 25,
                          color: dynamicTheme.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 18.sp, color: dynamicTheme.white),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        '$date',
                        style: TextStyle(
                            fontSize: 14.sp, color: dynamicTheme.white60),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$summa',
                    style:
                        TextStyle(fontSize: 18.sp, color: dynamicTheme.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
