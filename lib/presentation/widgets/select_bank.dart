import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ core/colors.dart';
import '../../data/bloc/collect_cubit.dart';
import '../../data/network/bank_id_save.dart';

class SelectBank extends StatefulWidget {
  const SelectBank({
    super.key,
  });

  @override
  State<SelectBank> createState() => _SelectBankState();
}

class _SelectBankState extends State<SelectBank> {
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
      height: 35.h,
      width: 140.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<DropDownButtonValueModel>(
          isExpanded: true,
          iconStyleData: IconStyleData(iconDisabledColor: dynamicTheme.white),
          value: dropdownValue,
          hint: Text(
            'Выбрать банк',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: dynamicTheme.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: list.map<DropdownMenuItem<DropDownButtonValueModel>>(
            (DropDownButtonValueModel item) {
              return DropdownMenuItem<DropDownButtonValueModel>(
                value: item,
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
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
            height: 50,
            width: 140.w,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: dynamicTheme.black,
                ),
                color: dynamicTheme.containerBackground),
            elevation: 0,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 145.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: dynamicTheme.containerColor,
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
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
