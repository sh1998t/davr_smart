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
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 3.w, right: 3.w),
            decoration: BoxDecoration(
              color: dynamicTheme.CardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: dynamicTheme.CardColor == Colors.white
                      ? Colors.grey.withOpacity(0.3)
                      : Color(0xFF1E1E1E).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            height: 50.h,
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
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: dynamicTheme.black12,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                width: 20,
                                color: dynamicTheme.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          spacing: 0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              '$name',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: dynamicTheme.white,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              '$date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: dynamicTheme.white60,
                              ),
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
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: dynamicTheme.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }
}
