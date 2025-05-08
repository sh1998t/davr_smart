import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../ core/colors.dart';

class CardWidgetStatus extends StatefulWidget {
  final String? name;
  final String? date;
  final double? summa;
  final double? height;
  final String? statusName;
  final VoidCallback? onevent;
  final Color color;
  const CardWidgetStatus(
      {super.key,
      required this.date,
      required this.name,
      required this.summa,
      required this.height,
      required this.statusName,
      required this.color,
      required this.onevent});

  @override
  State<CardWidgetStatus> createState() => _CardWidgetStatusState();
}

class _CardWidgetStatusState extends State<CardWidgetStatus> {
  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: dynamicTheme.CardColor,
                borderRadius: BorderRadius.circular(15.r),
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
              height: widget.height,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: widget.onevent,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 4, left: 6.w, right: 14.w, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5FAFF),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                width: 20,
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
                                '${widget.name}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: dynamicTheme.white,
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                '${widget.date}',
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.summa}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: dynamicTheme.white,
                            ),
                          ),
                          Text(
                            '${widget.statusName}',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: widget.color,
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
      ),
    );
  }
}
