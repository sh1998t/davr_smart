import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ core/colors.dart';

class CustomToggleButton extends StatefulWidget {
  final List<String> labels;
  final int initialIndex;
  final ValueChanged<int> onToggle;

  const CustomToggleButton({
    Key? key,
    required this.labels,
    this.initialIndex = 0,
    required this.onToggle,
  }) : super(key: key);

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void toggle(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onToggle(index);
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: dynamicTheme.grey600,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(widget.labels.length, (index) {
          bool isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => toggle(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? dynamicTheme.deepPurple
                      : dynamicTheme.grey600,
                  borderRadius: BorderRadius.horizontal(
                    left: index == 0 ? Radius.circular(10) : Radius.zero,
                    right: index == widget.labels.length - 1
                        ? Radius.circular(10)
                        : Radius.zero,
                  ),
                ),
                child: Text(
                  widget.labels[index],
                  style: TextStyle(
                    color: isSelected ? dynamicTheme.black : dynamicTheme.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
