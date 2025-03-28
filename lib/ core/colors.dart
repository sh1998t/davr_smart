import 'package:flutter/material.dart';

class MainColor {
  static final darkTheme = ThemeColors(
      CardColor: Color(0xFF1E1E1E),
      white: Color(0xffFFFFFF),
      black: Color(0xff000000),
      hintText: Color(0xFFC8C8C8),
      backgroundColor: Color(0xFF000000),
      appBarBackgroundColor: Color(0xFF000000),
      black12: Colors.black12,
      black38: Colors.white38,
      white60: Colors.white60,
      white38: Colors.white38,
      opacityColorsTop: Color(0xFF1D1D1D),
      opacityColorsButton: Color(0xFF313137),
      containerBackground: Color(0xFF0F0F0F),
      containerColor: Color(0xff1D1D1D),
      deepPurple: Colors.deepPurple,
      grey600: Colors.grey[600]!,
      color303030: Color(0xFF303030),
      color202020: Color(0xFF202020),
      topColor: Color(0xFF343747),
      iconColor: Color(0xFF53637A),
      buttonColor: Color(0xFF14171F),
      inputColor: Color(0xFF293A4F),
      borderColor: Color(0xFF53637A));

  static final lightTheme = ThemeColors(
      borderColor: Colors.white,
      inputColor: Colors.white,
      CardColor: Colors.white,
      iconColor: Color(0xFFB0BCCF),
      white: Color(0xff000000),
      black: Color(0xffFFFFFF),
      hintText: Color(0xFF757575),
      backgroundColor: Color(0xFFF7F7F7),
      appBarBackgroundColor: Color(0xFFF7F7F7),
      black12: Colors.grey[300],
      white60: Colors.black54,
      white38: Colors.black38,
      opacityColorsTop: Color(0xFFD0D0D0),
      opacityColorsButton: Color(0xFFE0E0E0),
      containerBackground: Color(0xFFFFFFFF),
      containerColor: Color(0xFFF0F0F0),
      deepPurple: Color(0xff572da6),
      grey600: Color(0xFFB2B0B0),
      color303030: Color(0xFFD0D0D0).withValues(alpha: 0.9),
      color202020: Color(0xFFE0E0E0).withValues(alpha: 0.9),
      black38: Colors.black38,
      buttonColor: Color(0xFFFFFFFF),
      topColor: Color(0xFFECEEF0));
}

class ThemeColors {
  final Color white;
  final Color black;
  final Color hintText;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Color? black12;
  final Color? black38;
  final Color white60;
  final Color white38;
  final Color opacityColorsTop;
  final Color opacityColorsButton;
  final Color containerBackground;
  final Color containerColor;
  final Color deepPurple;
  final Color grey600;
  final Color color303030;
  Color color202020;
  final Color CardColor;
  final Color iconColor;
  final Color topColor;
  final Color buttonColor;
  final Color inputColor;
  final Color borderColor;
  ThemeColors(
      {required this.white,
      required this.black,
      required this.hintText,
      required this.backgroundColor,
      required this.appBarBackgroundColor,
      required this.black12,
      required this.black38,
      required this.white60,
      required this.white38,
      required this.opacityColorsTop,
      required this.opacityColorsButton,
      required this.containerBackground,
      required this.containerColor,
      required this.deepPurple,
      required this.grey600,
      required this.color202020,
      required this.color303030,
      required this.topColor,
      required this.buttonColor,
      required this.CardColor,
      required this.iconColor,
      required this.borderColor,
      required this.inputColor});
}
