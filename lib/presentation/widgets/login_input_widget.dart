import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ core/colors.dart';

class LoginInputWidget extends StatelessWidget {
  const LoginInputWidget(
      {super.key,
      this.prefix,
      this.suffix,
      this.inputFormatters,
      this.hintText,
      this.style,
      this.width,
      this.height,
      this.keyboardType,
      this.textAlign,
      this.maxLength,
      this.controller,
      this.onchange,
      this.contentPadding,
      this.validator,
      this.textCapitalization,
      this.obscureText = false});

  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final TextStyle? style;
  final double? width;
  final double? height;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged? onchange;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;

  final TextCapitalization? textCapitalization;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return TextFormField(
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onchange,
      validator: validator,
      style: TextStyle(
          color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.w500),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.only(left: 1.w, top: 15.h, bottom: 0.h),
        prefix: const SizedBox(),
        prefixIcon: prefix,
        suffixIcon: Padding(
          padding:
              EdgeInsets.only(top: 5.h), // shu yer bilan balandligini sozlaysiz
          child: suffix,
        ),
        fillColor: dynamicTheme.CardColor,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.black.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF53637A),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
