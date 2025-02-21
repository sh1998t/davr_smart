import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFF1A1A3F),
        rightDotColor: const Color(0xFFEA3799),
        size: 200,
      ),
    ));
  }
}
