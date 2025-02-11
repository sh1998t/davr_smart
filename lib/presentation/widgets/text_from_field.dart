import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/color.dart';

class MainTextField extends StatelessWidget {
  const MainTextField({
    super.key,
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
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title?.isNotEmpty ?? false,
          child: Text(
            "  $title" ?? '',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
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
            style: const TextStyle(color: Colors.white),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              prefix: const SizedBox(),
              prefixIcon: prefix,
              fillColor: Color(0xFF293A4F),
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.hintText,
                  fontWeight: FontWeight.w500),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Color(0xFF53637A),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Color(0xFF53637A),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
