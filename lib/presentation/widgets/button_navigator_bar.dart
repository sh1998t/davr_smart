import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/presentation/screens/deposit_screen.dart';
import 'package:incasator/presentation/screens/precessing_screen.dart';
import 'package:incasator/presentation/screens/profile_screen.dart';
import 'package:incasator/presentation/screens/qr_code_scaner.dart';

import '../screens/history_screen.dart';

class ButtonNavigationBarWidget extends StatefulWidget {
  const ButtonNavigationBarWidget({super.key});
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFF0D1B2A),
        style: TabStyle.fixedCircle,
        color: Color(0xFF0D1B2A),
        curveSize: 25,
        top: -25,
        initialActiveIndex: page,
        height: 45.h,
        items: [
          TabItem(
            icon: Icon(Icons.edit_document, color: Colors.white38),
            activeIcon: Icon(Icons.edit_document, color: Colors.white),
            title: '',
          ),
          TabItem(
            icon: Icon(Icons.account_balance, color: Colors.white38),
            activeIcon: Icon(Icons.account_balance, color: Colors.white),
            title: '',
          ),
          TabItem(
            icon: Icon(Icons.qr_code, color: Colors.white, size: 36),
            activeIcon: Icon(Icons.qr_code, color: Colors.white, size: 36),
            title: '',
          ),
          TabItem(
            icon: Icon(Icons.history, color: Colors.white38),
            activeIcon: Icon(Icons.history, color: Colors.white),
            title: '',
          ),
          TabItem(
            icon: Icon(Icons.settings, color: Colors.white38),
            activeIcon: Icon(Icons.settings, color: Colors.white),
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
