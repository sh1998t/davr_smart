import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:incasator/data/bloc/collect_cubit.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:incasator/data/network/deposit_send.dart';
import 'package:incasator/presentation/widgets/select_bank.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ShowDialogDepositScreen extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? image;
  final String? comment;
  const ShowDialogDepositScreen(
      {super.key,
      required this.depositId,
      required this.login,
      required this.statusName,
      required this.date,
      required this.summa,
      required this.image,
      required this.comment});

  @override
  State<ShowDialogDepositScreen> createState() =>
      _ShowDialogDepositScreenState();
}

class _ShowDialogDepositScreenState extends State<ShowDialogDepositScreen> {
  final picker = ImagePicker();
  XFile? image;

  Future getCamera() async {
    final XFile? pickerCamera = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 1000, imageQuality: 100);
    setState(() {
      if (pickerCamera != null) {
        image = XFile(pickerCamera.path);
        context.read<CollectCubit>().addChekPhoto(image!.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> convertImageToPdf() async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, avval rasm tanlang!")),
      );
      return;
    }

    final pdf = pw.Document();
    final imageBytes = pw.MemoryImage(File(image!.path).readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(imageBytes));
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final file = File("${directory!.path}/image_to_pdf.pdf");
    await file.writeAsBytes(await pdf.save());

    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF ochishda xatolik: ${result.message}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saqlandi va ochildi: ${file.path}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 410.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    dynamicTheme.color303030,
                    dynamicTheme.color202020,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: dynamicTheme.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Статус ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: dynamicTheme.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${widget.statusName}',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: dynamicTheme.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.summa}",
                      style: TextStyle(
                          color: dynamicTheme.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: dynamicTheme.containerBackground),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {},
                              child: Text(
                                'документ',
                                style: TextStyle(
                                    fontSize: 16.sp, color: dynamicTheme.white),
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        image != null
                            ? Container(
                                height: 35.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: dynamicTheme.containerBackground),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide.none,
                                      padding: EdgeInsets.all(0),
                                    ),
                                    onPressed: convertImageToPdf,
                                    child: Text(
                                      'документ',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: dynamicTheme.white),
                                    )),
                              )
                            : Container(
                                height: 35.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: dynamicTheme.containerBackground),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide.none,
                                      padding: EdgeInsets.all(0),
                                    ),
                                    onPressed: () {
                                      getCamera();
                                    },
                                    child: Text(
                                      'Камера',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: dynamicTheme.white),
                                    )),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SelectBank(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 35.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: dynamicTheme.containerBackground),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              padding: EdgeInsets.all(0),
                            ),
                            onPressed: () {
                              final collectCubit = context.read<CollectCubit>();

                              final bankId = collectCubit.bankIds.isNotEmpty
                                  ? collectCubit.bankIds.last
                                  : null;
                              final chekPhoto =
                                  collectCubit.imagePaths.isNotEmpty
                                      ? collectCubit.imagePaths.last
                                      : null;
                              DepositSend()
                                  .request(widget.depositId, chekPhoto, bankId)
                                  .then((onValue) async {
                                if (onValue == true) {
                                  CherryToast.success(
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    inheritThemeColors: true,
                                    animationType: AnimationType.fromTop,
                                    title: Text('Успех!'),
                                    description:
                                        Text('Данные успешно загружены!'),
                                  ).show(context);

                                  await context
                                      .read<DepositCubit>()
                                      .fetchDeposits();
                                  Navigator.pop(context);
                                } else if (onValue == false) {}
                              });
                            },
                            child: Text(
                              'Подтвердить',
                              style: TextStyle(
                                  fontSize: 16.sp, color: dynamicTheme.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 315.h,
              color: dynamicTheme.containerColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'логин',
                    style:
                        TextStyle(fontSize: 18.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    '${widget.login}',
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'дата ',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    '${widget.date}',
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Сумма',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    "${widget.summa}",
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'комментария ',
                    style:
                        TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
                  ),
                  Text(
                    "${widget.comment}",
                    style:
                        TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
