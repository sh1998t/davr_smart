import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ core/colors.dart';

class MainTextField extends StatelessWidget {
  const MainTextField(
      {super.key,
      this.prefix,
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
      this.title,
      this.textCapitalization,
      this.obscureText = false});

  final Widget? prefix;
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
  final String? title;
  final TextCapitalization? textCapitalization;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title?.isNotEmpty ?? false,
          child: Text(
            "  $title" ?? '',
            style: TextStyle(fontSize: 18, color: dynamicTheme.white),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
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
          width: width,
          height: height,
          child: TextFormField(
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            controller: controller,
            textAlign: textAlign ?? TextAlign.start,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            onChanged: onchange,
            validator: validator,
            style: TextStyle(color: dynamicTheme.white),
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              prefix: const SizedBox(),
              prefixIcon: prefix,
              fillColor: dynamicTheme.CardColor,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: 14,
                  color: MainColor.darkTheme.white,
                  fontWeight: FontWeight.w500),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(15),
              //   borderSide: BorderSide(
              //     color: dynamicTheme.borderColor,
              //     width: 1.5,
              //   ),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(15),
              //   borderSide: BorderSide(
              //     color: Color(0xFF53637A),
              //     width: 1.5,
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
