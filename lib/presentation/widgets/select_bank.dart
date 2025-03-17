import 'package:adaptive_theme/adaptive_theme.dart';
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
      width: 145.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: dynamicTheme.containerBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: DropdownButton<DropDownButtonValueModel>(
                value: dropdownValue,
                iconSize: 50.sp,
                elevation: 16,
                hint: Center(
                  child: Text(
                    '    Выбрать банк',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                underline: SizedBox(height: 1, width: 180.w),
                onChanged: (DropDownButtonValueModel? value) {
                  if (value != null) {
                    setState(() {
                      dropdownValue = value;
                      context.read<CollectCubit>().addBankId(value.value!);
                    });
                  }
                },
                items: list.map<DropdownMenuItem<DropDownButtonValueModel>>(
                  (DropDownButtonValueModel item) {
                    return DropdownMenuItem<DropDownButtonValueModel>(
                      value: item,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Center(
                            child: Text(
                              '  ${item.label}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
                icon: const SizedBox.shrink(),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
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
