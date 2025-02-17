import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowDialogDepositScreen extends StatelessWidget {
  const ShowDialogDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
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
                    Color(0xFF303030),
                    Color(0xFF202020),
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Успешно",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Оплата",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "2500000",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35.h,
                          width: 140.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF0F0F0F)),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                side: BorderSide.none,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Отклонение',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
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
                              color: Color(0xFF0F0F0F)),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: 250.h,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100.w,
                                        child: Column(
                                          children: [
                                            Text('data'),
                                            Text('data'),
                                            Text('data'),
                                            Text('data'),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Принятие',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.white),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.59,
              color: Color(0xff1D1D1D),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    'Kassir Name',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Status ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    'Status Name',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'date ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    '12:00 00.00',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Summa',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white38),
                  ),
                  Text(
                    '100000000',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
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
