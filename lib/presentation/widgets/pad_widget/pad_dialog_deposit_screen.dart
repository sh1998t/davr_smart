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
import 'package:incasator/presentation/widgets/pad_widget/pad_select_bank.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/bloc/deposit_bloc/deposit_cubit.dart';
import '../../../data/network/deposit_send.dart';

class PadDialogDepositScreen extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final Widget? selectBank;
  final String? bankName;
  final String? operatorImage;
  final String? comment;
  final String? courierImage;
  const PadDialogDepositScreen({
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
  State<PadDialogDepositScreen> createState() =>
      _ShowDialogDepositScreenState();
}

class _ShowDialogDepositScreenState extends State<PadDialogDepositScreen> {
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
  }

  Future<void> openImageFromUrl() async {
    try {
      if (File(imageUrl!).existsSync()) {
        final result = await OpenFile.open(imageUrl!);
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
      }
    } catch (e) {}
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
    return Column(
      children: [
        Container(
          height: 300.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFF5FAFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
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
                Text(
                  'Статус ',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '${widget.statusName}',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: dynamicTheme.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 11.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.h,
                      width: 225.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color.fromRGBO(255, 255, 255, 1)),
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
                                fontSize: 12.sp,
                                color: Color.fromRGBO(1, 2, 6, 1)),
                          )),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    image != null
                        ? Container(
                            height: 50.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: dynamicTheme.containerBackground,
                            ),
                            child: Stack(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    padding: EdgeInsets.only(left: 5.w),
                                  ),
                                  onPressed: convertImageToPdf,
                                  child: Icon(
                                    Icons.file_copy_sharp,
                                    size: 16.sp,
                                    color: Color.fromRGBO(1, 2, 6, 1),
                                  ),
                                ),
                                Positioned(
                                  left: 50.w,
                                  top: 0.h,
                                  bottom: 0.h,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: Icon(
                                      Icons.close,
                                      size: 16.sp,
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
                            height: 50.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: dynamicTheme.containerBackground),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  padding: EdgeInsets.all(0),
                                ),
                                onPressed: () {
                                  getCamera();
                                },
                                child: Image.asset(
                                  'assets/images/camera_icon.png',
                                  width: 25.w,
                                  height: 25.h,
                                  fit: BoxFit.cover,
                                )),
                          ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: PadSelectBank(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: Container(
                    height: 50.h,
                    width: 350.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Color.fromRGBO(87, 46, 166, 1)),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () async {
                          final collectCubit = context.read<CollectCubit>();
                          final chekPhoto = collectCubit.imagePaths.isNotEmpty
                              ? collectCubit.imagePaths.last
                              : null;
                          final bankId = collectCubit.bankIds.isNotEmpty
                              ? collectCubit.bankIds.last
                              : null;
                          print(bankId);
                          if (bankId == null || bankId <= 0) {
                            CherryToast.error(
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              inheritThemeColors: true,
                              animationType: AnimationType.fromTop,
                              title: const Text('Ошибка!'),
                              description: const Text(
                                  "Пожалуйста, выберите банк. ID банка не найден."),
                            ).show(context);
                          } else {
                            try {
                              bool isSuccess = await DepositSend().request(
                                widget.depositId,
                                bankId,
                                chekPhoto,
                              );

                              if (isSuccess) {
                                CherryToast.success(
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                  inheritThemeColors: true,
                                  animationType: AnimationType.fromTop,
                                  title: const Text('Успешный!'),
                                  description:
                                      const Text('Данные успешно загружены!'),
                                ).show(context);

                                await context
                                    .read<DepositCubit>()
                                    .fetchDeposits();
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              CherryToast.error(
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                inheritThemeColors: true,
                                animationType: AnimationType.fromTop,
                                title: const Text('Ошибка!'),
                                description: Text(e.toString()),
                              ).show(context);
                            }
                          }
                        },
                        child: Text(
                          'Подтвердить',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30, bottom: 0, right: 30.w),
          width: MediaQuery.of(context).size.width,
          height: 270.h,
          color: dynamicTheme.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 0.h,
            children: [
              SizedBox(height: 12.h),
              Text(
                'Логин',
                style: TextStyle(
                    height: 0,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(109, 109, 109, 1)),
              ),
              Text(
                '${widget.login}',
                style: TextStyle(
                    height: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
              SizedBox(height: 15.h),
              Text(
                'Дата ',
                style: TextStyle(
                    height: 0,
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: Color.fromRGBO(109, 109, 109, 1)),
              ),
              Text(
                '${widget.date}',
                style: TextStyle(
                    height: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
              SizedBox(height: 15.h),
              Text(
                'Сумма',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    height: 0,
                    fontSize: 12.sp,
                    color: dynamicTheme.white38),
              ),
              Text(
                "${widget.summa}",
                style: TextStyle(
                    height: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
              SizedBox(height: 15.h),
              Text(
                'комментария ',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    height: 0,
                    fontSize: 12.sp,
                    color: Color.fromRGBO(109, 109, 109, 1)),
              ),
              Text(
                "${widget.comment}",
                style: TextStyle(
                    height: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
