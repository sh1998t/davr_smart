import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../ core/auth_util.dart';
import '../../ core/base_api_requrest.dart';
import '../widgets/button_navigator_bar.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await AuthUtil.getToken();

    if (token == null) {
      navigateTo(const LoginScreen());
    } else {
      try {
        final response = await BaseApiRequest().getRequest('/me');
        if (response.statusCode == 200) {
          navigateTo(const ButtonNavigationBarWidget());
        } else {
          navigateTo(const LoginScreen());
        }
      } catch (_) {
        navigateTo(const LoginScreen());
      }
    }
  }

  void navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF572DA6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_davr.png",
                width: 140.w,
                height: 220.h,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 130.h,
              ),
              SpinKitFadingCircle(
                color: Colors.white,
                size: 40.h,
              ),
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )
            ],
          ),
        ));
  }
}
