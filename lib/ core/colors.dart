import 'package:flutter/material.dart';

class MainColor {
  static final darkTheme = ThemeColors(
    white: Color(0xffFFFFFF),
    black: Color(0xff000000),
    hintText: Color(0xFFC8C8C8),
    backgroundColor: Color(0xFF25364A),
    appBarBackgroundColor: Color(0xFF0D1B2A),
    black12: Colors.black12,
    white60: Colors.white60,
    white38: Colors.white38,
    opacityColorsTop: Color(0xFF303030),
    opacityColorsButton: Color(0xFF202020),
    containerBackground: Color(0xFF0F0F0F),
    containerColor: Color(0xff1D1D1D),
  );

  static final lightTheme = ThemeColors(
    white: Color(0xffFFFFFF),
    black: Color(0xff000000),
    hintText: Color(0xFF757575),
    backgroundColor: Color(0xFFF5F5F5),
    appBarBackgroundColor: Color(0xFFFFFFFF),
    black12: Colors.black12.withOpacity(0.08),
    white60: Colors.white70,
    white38: Colors.white54,
    opacityColorsTop: Color(0xFFE0E0E0),
    opacityColorsButton: Color(0xFFEEEEEE),
    containerBackground: Color(0xFFFFFFFF),
    containerColor: Color(0xFFEFEFEF),
  );
}

class ThemeColors {
  final Color white;
  final Color black;
  final Color hintText;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Color black12;
  final Color white60;
  final Color white38;
  final Color opacityColorsTop;
  final Color opacityColorsButton;
  final Color containerBackground;
  final Color containerColor;

  ThemeColors({
    required this.white,
    required this.black,
    required this.hintText,
    required this.backgroundColor,
    required this.appBarBackgroundColor,
    required this.black12,
    required this.white60,
    required this.white38,
    required this.opacityColorsTop,
    required this.opacityColorsButton,
    required this.containerBackground,
    required this.containerColor,
  });
}
