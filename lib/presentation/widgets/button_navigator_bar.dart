import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/presentation/screens/deposit_screen.dart';
import 'package:incasator/presentation/screens/precessing_screen.dart';
import 'package:incasator/presentation/screens/profile_screen.dart';
import 'package:incasator/presentation/screens/qr_code_scaner.dart';

import '../../ core/colors.dart';
import '../../data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import '../screens/history_screen.dart';

class ButtonNavigationBarWidget extends StatefulWidget {
  final int initialIndex;
  const ButtonNavigationBarWidget({super.key, this.initialIndex = 0});
  @override
  State<ButtonNavigationBarWidget> createState() => _ButtonNavigationBarState();
}

class _ButtonNavigationBarState extends State<ButtonNavigationBarWidget> {
  var page = 0;
  final pages = [
    PrecessingScreen(),
    DepositScreen(),
    QrCodeScanner(),
    HistoryScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    page = widget.initialIndex;
    context.read<ProcessingCubit>().fetchProcessing();
  }

  @override
  Widget build(BuildContext context) {
    // AuthUtil.checkIsAuth().then((value) {}).catchError((error) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LoginScreen()),
    //   );
    // });

    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
      // fixedCircle
      body: pages[page],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFFF5FAFF),
        cornerRadius: 5,
        style: TabStyle.fixedCircle,
        color: Colors.deepPurple,
        curveSize: 25,
        top: -25,
        initialActiveIndex: page,
        height: 60.h,
        items: [
          TabItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Icon(Icons.edit_document, color: dynamicTheme.white38),
            ),
            activeIcon: Icon(Icons.edit_document, color: Colors.deepPurple),
            title: '',
          ),
          TabItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Icon(Icons.account_balance, color: dynamicTheme.white38),
            ),
            activeIcon: Icon(Icons.account_balance, color: Colors.deepPurple),
            title: '',
          ),
          TabItem(
            icon: Icon(Icons.qr_code, color: Colors.white, size: 36),
            activeIcon: Icon(Icons.qr_code, color: Colors.deepPurple, size: 36),
            title: '',
          ),
          TabItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Icon(Icons.history, color: dynamicTheme.white38),
            ),
            activeIcon: Icon(Icons.history, color: Colors.deepPurple),
            title: '',
          ),
          TabItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Icon(Icons.settings, color: dynamicTheme.white38),
            ),
            activeIcon: Icon(Icons.settings, color: Colors.deepPurple),
            title: '',
          ),
        ],
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
      ),
    );
  }
}
