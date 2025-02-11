import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:incasator/presentation/screens/deposit_screen/deposit_screen.dart';
import 'package:incasator/presentation/screens/profile_screen/profile_screen.dart';

import '../screens/history/history_screen.dart';
import '../screens/processing_screen/precessing_screen.dart';

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
    HistoryScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFF0D1B2A),
        style: TabStyle.fixedCircle,
        activeColor: Colors.white,
        color: Colors.white38,
        initialActiveIndex: page,
        items: [
          TabItem(icon: Icons.edit_document, title: ''),
          TabItem(icon: Icons.account_balance, title: ''),
          TabItem(
            icon: Icon(
              Icons.qr_code,
              color: Colors.white,
              size: 36,
            ),
            title: '',
          ),
          TabItem(icon: Icons.history, title: ''),
          TabItem(icon: Icons.settings, title: ''),
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
