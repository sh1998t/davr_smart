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
  final String? bankName;
  const DiologWidget(
      {super.key,
      required this.depositId,
      required this.login,
      required this.statusName,
      required this.date,
      required this.summa,
      required this.operatorImage,
      required this.comment,
      required this.courierImage,
      this.bankName});

  @override
  State<DiologWidget> createState() => _ShowDialogDepositScreenState();
}

class _ShowDialogDepositScreenState extends State<DiologWidget> {
  String? operatorImageUrl;
  String? courierImageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.operatorImage != null && widget.operatorImage is String) {
      operatorImageUrl = "${widget.operatorImage}";
    }

    if (widget.courierImage != null && widget.courierImage is String) {
      courierImageUrl = "${widget.courierImage}";
    }
  }

  Future<void> openImageFromUrl(String? imageUrl, String type) async {
    print("url :::::  $imageUrl");
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("")),
      );
      return;
    }

    try {
      if (File(imageUrl).existsSync()) {
        final result = await OpenFile.open(imageUrl);

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
    return Column(
      children: [
        Container(
          height: 220.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.r),
              topRight: Radius.circular(26.r),
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
                          onPressed: () =>
                              openImageFromUrl(operatorImageUrl, "Operator"),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: dynamicTheme.white),
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
          height: 340.h,
          color: dynamicTheme.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'логин',
                style: TextStyle(fontSize: 18.sp, color: dynamicTheme.white38),
              ),
              Text(
                '${widget.login}',
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
              SizedBox(
                height: 20.h,
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
                height: 20.h,
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
                height: 20.h,
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
                height: 20.h,
              ),
              Text(
                'Банк ',
                style: TextStyle(fontSize: 14.sp, color: dynamicTheme.white38),
              ),
              Text(
                "${widget.bankName}",
                style: TextStyle(fontSize: 16.sp, color: dynamicTheme.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
