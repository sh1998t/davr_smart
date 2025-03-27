import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/%20core/colors.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DiologWidget extends StatefulWidget {
  final int? depositId;
  final String? login;
  final String? statusName;
  final String? date;
  final double? summa;
  final String? operatorImage;
  final String? comment;
  final String? courierImage;
  const DiologWidget(
      {super.key,
      required this.depositId,
      required this.login,
      required this.statusName,
      required this.date,
      required this.summa,
      required this.operatorImage,
      required this.comment,
      required this.courierImage});

  @override
  State<DiologWidget> createState() => _ShowDialogDepositScreenState();
}

class _ShowDialogDepositScreenState extends State<DiologWidget> {
  String? operatorImageUrl;
  String? courierImageUrl;

  @override
  void initState() {
    super.initState();
    // OperatorImage URL ni olish
    if (widget.operatorImage != null && widget.operatorImage is String) {
      operatorImageUrl = "${widget.operatorImage}";
    }
    // CourierImage URL ni olish
    if (widget.courierImage != null && widget.courierImage is String) {
      courierImageUrl = "${widget.courierImage}";
    }
  }

  // Umumiy funksiya: URL'dan rasmni yuklab ochish
  Future<void> openImageFromUrl(String? imageUrl, String type) async {
    print("url :::::  $imageUrl");
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Iltimos, avval rasm URL'sini tekshiring!")),
      );
      return;
    }

    try {
      // Agar URL mahalliy fayl yo'li bo'lsa
      if (File(imageUrl).existsSync()) {
        final result = await OpenFile.open(imageUrl);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochishda xatolik: ${result.message}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$type fayl ochildi: $imageUrl")),
          );
        }
        return;
      }

      Dio dio = Dio();
      final response = await dio.get(
        imageUrl,
        options:
            Options(responseType: ResponseType.bytes), // Byte formatida olish
      );

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final file = File("${directory!.path}/downloaded_${type}_image.jpg");
        await file.writeAsBytes(response.data);

        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fayl ochishda xatolik: ${result.message}")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$type fayl ochildi: ${file.path}")),
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
      operatorImageUrl = null;
      courierImageUrl = null;
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
              height: MediaQuery.of(context).size.height - 490.h,
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
                              onPressed: () => openImageFromUrl(
                                  operatorImageUrl, "Operator"),
                              child: Text(
                                'документ',
                                style: TextStyle(
                                    fontSize: 16.sp, color: dynamicTheme.white),
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
                              onPressed: () =>
                                  openImageFromUrl(courierImageUrl, "Courier"),
                              child: Text(
                                'документ',
                                style: TextStyle(
                                    fontSize: 16.sp, color: dynamicTheme.white),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 352.h,
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
