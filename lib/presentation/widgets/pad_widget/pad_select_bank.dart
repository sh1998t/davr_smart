import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ core/colors.dart';
import '../../../data/bloc/collect_cubit.dart';
import '../../../data/network/bank_id_save.dart';

class PadSelectBank extends StatefulWidget {
  const PadSelectBank({
    super.key,
  });

  @override
  State<PadSelectBank> createState() => _PadSelectBankState();
}

class _PadSelectBankState extends State<PadSelectBank> {
  DropDownButtonValueModel? dropdownValue;
  List<DropDownButtonValueModel> list = []; // Bo'sh ro'yxat bilan boshlaymiz
  final BankIdSave bankIdSave = BankIdSave(); // BankIdSave obyekti

  @override
  void initState() {
    super.initState();
    _loadBankData();
  }

  Future<void> _loadBankData() async {
    try {
      await bankIdSave.bankIdRequest();
    } catch (e) {
      print('Bank ma\'lumotlarini yuklashda xato: $e');
    }

    List<dynamic> bankData = await bankIdSave.getBankIdData();

    setState(() {
      list = bankData.map((data) {
        return DropDownButtonValueModel(
          value: data['id'] as int?,
          label: data['name'] as String,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Container(
      height: 40.h,
      width: 160.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<DropDownButtonValueModel>(
          isExpanded: true,
          iconStyleData: IconStyleData(iconDisabledColor: dynamicTheme.white),
          value: dropdownValue,
          hint: Center(
            child: Text(
              'Выбрать банк',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: dynamicTheme.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          items: list.map<DropdownMenuItem<DropDownButtonValueModel>>(
            (DropDownButtonValueModel item) {
              return DropdownMenuItem<DropDownButtonValueModel>(
                value: item,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: dynamicTheme.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ).toList(),
          onChanged: (DropDownButtonValueModel? value) {
            if (value != null) {
              setState(() {
                dropdownValue = value;
                context.read<CollectCubit>().addBankId(value.value!);
              });
            }
          },
          buttonStyleData: ButtonStyleData(
            height: 40.h,
            width: 160.w,
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.w),
                border: Border.all(
                  color: dynamicTheme.black,
                ),
                color: dynamicTheme.containerBackground),
            elevation: 0,
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 5,
            maxHeight: 200.h,
            width: 160.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: dynamicTheme.black,
            ),
            offset: Offset(0, -8),
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(8.r),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 40.h,
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
          ),
        ),
      ),
    );
  }
}

class DropDownButtonValueModel {
  final int? value;
  final String label;

  DropDownButtonValueModel({
    required this.value,
    required this.label,
  });
}
