import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Agar ishlatilsa

import '../widgets/button_navigator_bar.dart';
import '../widgets/text_from_field.dart';

class LoginScreen extends StatefulWidget {
  static String name = 'login_screen';
  static String path = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF31435B),
                    Color(0xFF25364A),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 110.h),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 120.h,
                    width: 120.w,
                  ),
                ),
                SizedBox(height: 90.h),
                Center(
                  child: Column(
                    children: [
                      MainTextField(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        prefix: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: const Color(0xFF53637A),
                        ),
                        title: "Login".tr(),
                        height: 43.h,
                        hintText: "Username",
                        width: 300.w,
                        controller: loginController,
                      ),
                      SizedBox(height: 10.h),
                      MainTextField(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        title: "Password".tr(),
                        height: 43.h,
                        hintText: "Password",
                        width: 300.w,
                        controller: passwordController,
                        prefix: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF53637A),
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      SizedBox(
                        height: 40.h,
                        width: MediaQuery.of(context).size.width - 150.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            backgroundColor: const Color(0xFF209A9A),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ButtonNavigationBarWidget(),
                                ));
                          },
                          child: Text(
                            "Sign In".tr(),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
