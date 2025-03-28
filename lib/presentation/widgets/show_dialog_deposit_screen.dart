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
import 'package:incasator/data/bloc/collect_cubit.dart';
import 'package:incasator/data/bloc/deposit_bloc/deposit_cubit.dart';
import 'package:incasator/data/network/deposit_send.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ShowDialogDepositScreen extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? selectBank;
  final String? bankName;
  final String? operatorImage;
  final String? comment;
  final String? courierImage; // Bu endi ixtiyoriy
  const ShowDialogDepositScreen({
    super.key,
    required this.depositId,
    required this.login,
    required this.statusName,
    required this.date,
    required this.summa,
    this.selectBank,
    this.bankName,
    required this.operatorImage,
    required this.comment,
    this.courierImage,
  });

  @override
  State<ShowDialogDepositScreen> createState() =>
      _ShowDialogDepositScreenState();
}

class _ShowDialogDepositScreenState extends State<ShowDialogDepositScreen> {
  final picker = ImagePicker();
  XFile? image;
  String? imageUrl;
  @override
  void initState() {
    super.initState();

    if (widget.operatorImage != null && widget.operatorImage is String) {
      imageUrl = "${widget.operatorImage}";
    }
  }

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

  void clearImage() {
    setState(() {
      image = null;
      imageUrl = null;
    });
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
              height: (widget.bankName == null)
                  ? (MediaQuery.of(context).size.height - 425.h)
                  : (MediaQuery.of(context).size.height - 455.h),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
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
                      'Статус ',
                      style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.deepPurple,
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
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: openImageFromUrl,
                              child: Text(
                                'документ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: dynamicTheme.white),
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
                                  color: dynamicTheme.containerBackground,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide.none,
                                          padding: EdgeInsets.all(0),
                                        ),
                                        onPressed: convertImageToPdf,
                                        child: Text(
                                          'документ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            color: dynamicTheme.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5.w,
                                      top: 5.h,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.close,
                                          size: 20.sp,
                                          color: dynamicTheme.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            clearImage();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: dynamicTheme.white),
                                    )),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: widget.selectBank,
                    ),
                    SizedBox(
                      height: 8,
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

                              if (bankId == null || bankId == 0) {
                                CherryToast.error(
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  inheritThemeColors: true,
                                  animationType: AnimationType.fromTop,
                                  title: Text('Xato!'),
                                  description: Text(""),
                                ).show(context);

                                return;
                              }

                              DepositSend()
                                  .request(widget.depositId, chekPhoto, bankId)
                                  .then((onValue) async {
                                if (onValue == true) {
                                  CherryToast.success(
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    inheritThemeColors: true,
                                    animationType: AnimationType.fromTop,
                                    title: Text('Muvaffaqiyat!'),
                                    description: Text(
                                        'Ma’lumotlar muvaffaqiyatli yuklandi!'),
                                  ).show(context);

                                  await context
                                      .read<DepositCubit>()
                                      .fetchDeposits();
                                  Navigator.pop(context);
                                } else {
                                  CherryToast.error(
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    inheritThemeColors: true,
                                    animationType: AnimationType.fromTop,
                                    title: Text('Xato!'),
                                    description: Text(
                                        'Ma’lumotlarni yuborishda xato. Qayta urinib ko‘ring.'),
                                  ).show(context);
                                }
                              });
                            },
                            child: Text(
                              'Подтвердить',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: dynamicTheme.white),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width,
              height: (widget.bankName == null)
                  ? (MediaQuery.of(context).size.height - 418.h)
                  : (MediaQuery.of(context).size.height - 385.h),
              color: dynamicTheme.containerColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
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
                    height: 15.h,
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
                    height: 15.h,
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
                    height: 15.h,
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
                  SizedBox(
                    height: 15.h,
                  ),
                  (widget.bankName == null)
                      ? Text('')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bank ',
                              style: TextStyle(
                                  fontSize: 14.sp, color: dynamicTheme.white38),
                            ),
                            Text(
                              "${widget.bankName}",
                              style: TextStyle(
                                  fontSize: 16.sp, color: dynamicTheme.white),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
