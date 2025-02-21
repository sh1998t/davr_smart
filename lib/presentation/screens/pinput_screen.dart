import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_screen.dart'; // 🔹 LoginScreen qo‘shildi
import '../widgets/button_navigator_bar.dart';

class SetPinScreen extends StatefulWidget {
  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _storage = FlutterSecureStorage();
  final _pinController = TextEditingController();
  String? _savedPin;
  bool _isSettingPin = false;
  String? _tempPin;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedPin();
  }

  void _checkSavedPin() async {
    _savedPin = await _storage.read(key: 'user_pin');
    setState(() {
      _isSettingPin = _savedPin == null;
    });
  }

  void _onPinEntered(String pin) async {
    if (_isSettingPin) {
      if (_tempPin == null) {
        setState(() {
          _tempPin = pin;
        });

        await Future.delayed(const Duration(seconds: 1));
        _pinController.clear();
      } else {
        if (pin == _tempPin) {
          setState(() {
            _isLoading = true;
          });

          await Future.delayed(const Duration(seconds: 2));
          await _savePin(pin);
        } else {
          _showError("PIN mos kelmadi! Qaytadan urinib ko‘ring.");
        }
      }
    } else {
      if (pin == _savedPin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ButtonNavigationBarWidget()),
        );
      } else {
        _showError("Noto‘g‘ri PIN! Qaytadan urinib ko‘ring.");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    _pinController.clear();
  }

  Future<void> _savePin(String pin) async {
    await _storage.write(key: 'user_pin', value: pin);
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PIN muvaffaqiyatli saqlandi!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ButtonNavigationBarWidget()),
    );
  }

  void _forgotPassword() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // 🔹 Login screen ga o'tish
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF25364A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF25364A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isSettingPin
                  ? (_tempPin == null
                      ? "Yangi PIN kiriting"
                      : "PIN ni tasdiqlang")
                  : "Ilovaga kirish uchun PIN kiriting",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Center(
              child: Pinput(
                length: 4,
                controller: _pinController,
                onCompleted: _onPinEntered,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToNextScreen,
              child: const Text(
                'Parolni unutdingizmi?',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Widget nextScreen = LoginScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
