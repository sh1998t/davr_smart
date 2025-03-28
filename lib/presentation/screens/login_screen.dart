import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:incasator/data/network/auth_api.dart';
import 'package:incasator/presentation/widgets/button_navigator_bar.dart';

import '../../ core/colors.dart';
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
    ThemeColors dynamicTheme = AdaptiveTheme.of(context).mode.isDark
        ? MainColor.darkTheme
        : MainColor.lightTheme;
    return Scaffold(
      backgroundColor: dynamicTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        prefix: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: dynamicTheme.white,
                        ),
                        title: "Login".tr(),
                        height: 43.h,
                        hintText: "Username",
                        width: 300.w,
                        controller: loginController,
                      ),
                      SizedBox(height: 10.h),
                      MainTextField(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        title: "Password".tr(),
                        height: 43.h,
                        hintText: "Password",
                        width: 300.w,
                        controller: passwordController,
                        obscureText: obscurePassword,
                        prefix: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: dynamicTheme.white,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        height: 40.h,
                        width: MediaQuery.of(context).size.width - 150.w,
                        decoration: BoxDecoration(
                          color: dynamicTheme.CardColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: dynamicTheme.CardColor == Colors.white
                                  ? Colors.grey.withOpacity(0.3)
                                  : Color(0xFF1E1E1E).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  30)), // Agar radius kerak bo'lsa
                            ),
                            backgroundColor: dynamicTheme.CardColor,
                            side: BorderSide.none, // Borderni olib tashlash
                          ),
                          onPressed: () async {
                            try {
                              await (AuthApiRequest()).request(
                                loginController.text,
                                passwordController.text,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ButtonNavigationBarWidget(),
                                ),
                              );
                            } catch (error) {
                              String errorMessage = error
                                  .toString()
                                  .replaceAll("Exception: ", "");
                              CherryToast.error(
                                animationDuration: Duration(milliseconds: 300),
                                inheritThemeColors: true,
                                animationType: AnimationType.fromTop,
                                title: Text('Ошибка!'),
                                description: Text(errorMessage),
                              ).show(context);
                            }
                          },
                          child: Text(
                            "Войти",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: dynamicTheme.white),
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
