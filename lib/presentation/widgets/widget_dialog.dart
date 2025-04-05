import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import '../../data/network/courier_accept_deposit.dart';

class WidgetDialog extends StatefulWidget {
  const WidgetDialog(
      {super.key,
      this.depositId,
      this.login,
      this.statusName,
      this.date,
      this.summa,
      this.image,
      this.comment});
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final String? image;
  final String? comment;

  @override
  State<WidgetDialog> createState() => _WidgetDialogState();
}

class _WidgetDialogState extends State<WidgetDialog> {
  final picker = ImagePicker();
  XFile? image;
  String? imageUrl;
  @override
  void initState() {
    super.initState();

    if (widget.image != null && widget.image is String) {
      imageUrl = "${widget.image}";
    }
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

  Future<void> openImageFromUrl() async {
    print("url :::::  ${imageUrl}");
    if (imageUrl == null || imageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Iltimos, avval rasm URL'sini tekshiring!")),
      );
      return;
    }

    try {
      if (File(imageUrl!).existsSync()) {
        final result = await OpenFile.open(imageUrl!);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochishda xatolik: ${result.message}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochildi: $imageUrl")),
          );
        }
        return;
      }
      Dio dio = Dio();
      final response = await dio.get(
        imageUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final file = File("${directory!.path}/downloaded_image.jpg");
        await file.writeAsBytes(response.data);

        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochishda xatolik: ${result.message}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochildi: ${file.path}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Rasmni yuklab olishda xatolik!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Column(
      children: [
        Container(
          height: 230.h,
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
              left: 30.w,
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
                  'Статус',
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  '${widget.statusName}',
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: dynamicTheme.white,
                      fontWeight: FontWeight.bold),
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
                  height: 15.h,
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
                            padding: EdgeInsets.all(0),
                            side: BorderSide.none,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Отклонить',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: dynamicTheme.white),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
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
                          onPressed: () {
                            CourierAcceptDeposit()
                                .request("${widget.depositId}")
                                .then(
                              (value) async {
                                if (value == true) {
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
                                      .read<ProcessingCubit>()
                                      .fetchProcessing();
                                  Navigator.pop(context);
                                } else {
                                  CherryToast.warning(
                                    inheritThemeColors: true,
                                    description: const Text(
                                      'Ошибка',
                                    ),
                                    animationType: AnimationType.fromTop,
                                    action: const Text(
                                        'Резервное копирование данных'),
                                    actionHandler: () {},
                                  ).show(context);
                                }
                              },
                            );
                          },
                          child: Text(
                            'Принять',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: dynamicTheme.white),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
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
                          padding: EdgeInsets.all(0),
                          side: BorderSide.none,
                        ),
                        onPressed: openImageFromUrl,
                        child: Text(
                          'Документ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: dynamicTheme.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30),
          width: MediaQuery.of(context).size.width,
          height: 250.h,
          color: dynamicTheme.containerColor,
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Логин',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white38),
              ),
              Text(
                '${widget.login}',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Дата ',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                '${widget.date}',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Сумма',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                "${widget.summa}",
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Комментария ',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                "${widget.comment}",
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
