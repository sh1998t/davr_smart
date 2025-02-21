import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:incasator/presentation/screens/login_screen.dart';
import 'package:incasator/presentation/screens/pinput_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.fadeIn(
        animationDuration: const Duration(seconds: 5),
        backgroundColor: const Color(0xFF323747),
        onInit: () {
          debugPrint("Splash started");
        },
        onEnd: () async {
          debugPrint("Splash ended");
          await Future.delayed(const Duration(seconds: 2), () {
            _navigateToNextScreen();
          });
        },
        childWidget: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset(
            "assets/images/logo.png",
            errorBuilder: (context, error, stackTrace) {
              debugPrint("Rasm yuklanmadi: $error");
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        ),
        onAnimationEnd: () => debugPrint("On Fade In End"),
      ),
    );
  }

  void _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRegistered = prefs.getBool('isRegistered') ?? false;

    Widget nextScreen = isRegistered ? SetPinScreen() : LoginScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
