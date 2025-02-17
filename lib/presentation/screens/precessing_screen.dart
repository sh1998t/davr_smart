import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/show_dialog_widget.dart';

class PrecessingScreen extends StatefulWidget {
  const PrecessingScreen({super.key});

  @override
  State<PrecessingScreen> createState() => _PrecessingScreenState();
}

class _PrecessingScreenState extends State<PrecessingScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B2A),
        centerTitle: true,
        leading: Text(''),
        toolbarHeight: 40.h,
        title: Text(
          "Обработка поступления",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Regular',
              fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Color(0xFF25364A),
      body: SingleChildScrollView(
        child: Column(
          spacing: 4.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              "  10 fevral",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5.h,
            ),
            CardWidget(),
            CardWidget(),
            CardWidget(),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "  9 fevral",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5.h,
            ),
            CardWidget(),
            CardWidget(),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ShowDialogWidget();
            },
          );
        },
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 42.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 25,
                      color: Colors.white,
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
                  Text(
                    'Ravshan Azizov',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white60),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '12345678',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                width: 110.w,
              ),
              Column(
                children: [
                  Text(
                    '12:45',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white60),
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
