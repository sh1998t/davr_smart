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
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/network/deposit_send_file.dart';

class ShowDialogSubmittedDepositScreen extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final String? bankName;
  final String? operatorImage;
  final String? comment;
  final String? courierPhoto;
  final double? height;
  const ShowDialogSubmittedDepositScreen({
    super.key,
    required this.depositId,
    required this.login,
    required this.statusName,
    required this.date,
    required this.summa,
    this.bankName,
    required this.operatorImage,
    required this.comment,
    this.courierPhoto,
    this.height,
  });

  @override
  State<ShowDialogSubmittedDepositScreen> createState() =>
      _ShowDialogSubmittedDepositScreenState();
}

class _ShowDialogSubmittedDepositScreenState
    extends State<ShowDialogSubmittedDepositScreen> {
  final picker = ImagePicker();
  XFile? image;
  String? imageUrl;
  String? imageUrlCourier;
  @override
  void initState() {
    super.initState();

    if (widget.courierPhoto != null && widget.courierPhoto is String) {
      imageUrlCourier = "${widget.courierPhoto}";
    }
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

  Future<void> openImageFromUrlCourier(String url) async {
    print("url :::::  ${url}");

    try {
      if (File(url).existsSync()) {
        final result = await OpenFile.open(url);
        return;
      }
      Dio dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final file = File("${directory!.path}/downloaded_image.jpg");
        await file.writeAsBytes(response.data);

        final result = await OpenFile.open(file.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: $e")),
      );
    }
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
    return Column(
      // (widget.courierPhoto != null) ? 200.h :
      children: [
        Container(
          height: (widget.courierPhoto != null) ? 230.h : 275.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(25),
            ),
            color: Color(0xFFF5FAFF),
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
                        onPressed: () {
                          openImageFromUrl();
                        },
                        child: Text(
                          'документ1',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: dynamicTheme.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    if (widget.courierPhoto != null)
                      Container(
                        height: 35.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: dynamicTheme.containerBackground,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            openImageFromUrlCourier(widget.courierPhoto!);
                          },
                          child: Text(
                            'документ2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: dynamicTheme.white,
                            ),
                          ),
                        ),
                      ),
                    if (widget.courierPhoto == null && image == null)
                      Container(
                        height: 35.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: dynamicTheme.containerBackground,
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: getCamera,
                          child: Text(
                            'Камера',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: dynamicTheme.white,
                            ),
                          ),
                        ),
                      ),
                    if (widget.courierPhoto == null && image != null)
                      Container(
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
                                onPressed:
                                    convertImageToPdf, // yoki kerakli funksiya
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
                              left: 102.w,
                              top: 0.h,
                              bottom: 10.h,
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
                      ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                if (widget.courierPhoto == null)
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
                          onPressed: () async {
                            final collectCubit = context.read<CollectCubit>();

                            final chekPhoto = collectCubit.imagePaths.isNotEmpty
                                ? collectCubit.imagePaths.last
                                : null;

                            if (image == null) {
                              CherryToast.error(
                                animationDuration: Duration(milliseconds: 300),
                                inheritThemeColors: true,
                                animationType: AnimationType.fromTop,
                                title: Text('Ошибка!'),
                                description: Text(
                                    "Пожалуйста, сначала загрузите фото с камеры"),
                              ).show(context);
                              return;
                            }

                            if (chekPhoto == null || chekPhoto == 0) {
                              CherryToast.error(
                                animationDuration: Duration(milliseconds: 300),
                                inheritThemeColors: true,
                                animationType: AnimationType.fromTop,
                                title: Text('Ошибка!'),
                                description: Text("Чек не найден"),
                              ).show(context);
                              return;
                            }

                            try {
                              bool isSuccess = await DepositSendFile().request(
                                widget.depositId,
                                chekPhoto,
                              );

                              if (isSuccess) {
                                CherryToast.success(
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  inheritThemeColors: true,
                                  animationType: AnimationType.fromTop,
                                  title: Text('Успешный!'),
                                  description:
                                      Text('Данные успешно загружены!'),
                                ).show(context);

                                await context
                                    .read<DepositCubit>()
                                    .fetchDeposits();
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              CherryToast.error(
                                animationDuration: Duration(milliseconds: 300),
                                inheritThemeColors: true,
                                animationType: AnimationType.fromTop,
                                title: Text('Ошибка!'),
                                description: Text(e
                                    .toString()), // API'dan kelgan message chiqadi
                              ).show(context);
                            }
                          },
                          child: Text(
                            'Подтвердить',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: dynamicTheme.white),
                          )),
                    ),
                  ),
                if (widget.courierPhoto != null) Text(''),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30),
          width: MediaQuery.of(context).size.width,
          height: (widget.courierPhoto != null) ? 340.h : 320.h,
          color: dynamicTheme.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                'логин',
                style: TextStyle(fontSize: 18.sp, color: dynamicTheme.white38),
              ),
              Text(
                '${widget.login}',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'дата ',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                '${widget.date}',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 15.h,
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
                height: 15.h,
              ),
              Text(
                'комментария ',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                "${widget.comment}",
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
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
    );
  }
}
