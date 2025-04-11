import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bloc/precessing_bloc/precessing_bloc_cubit.dart';
import '../../data/network/courier_accept_deposit.dart';
import '../widgets/button_navigator_bar.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FAFF),
      body: AiBarcodeScanner(
        cutOutSize: 240,
        hideGalleryButton: true,
        bottomSheetBuilder: (context, controller) => const SizedBox.shrink(),
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) async {
          final String? scannedCode = capture.barcodes.first.rawValue;

          if (scannedCode != null && !isProcessing) {
            setState(() {
              isProcessing = true;
            });

            print("QR code detected: $scannedCode");

            final bool success =
                await CourierAcceptDeposit().request(scannedCode);

            if (!mounted) return;

            if (success) {
              CherryToast.success(
                animationDuration: const Duration(milliseconds: 300),
                inheritThemeColors: true,
                animationType: AnimationType.fromTop,
                title: const Text('Успех!'),
                description: const Text('Данные успешно загружены!'),
              ).show(context);

              await context.read<ProcessingCubit>().fetchProcessing();

              // 👉 Navigate to DepositScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ButtonNavigationBarWidget(initialIndex: 1),
                ),
              );
            } else {
              CherryToast.warning(
                inheritThemeColors: true,
                description: const Text('Ошибка'),
                animationType: AnimationType.fromTop,
                action: const Text('Резервное копирование данных'),
                actionHandler: () {},
              ).show(context);
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ButtonNavigationBarWidget(initialIndex: 0),
              ),
            );
            setState(() {
              isProcessing = false;
            });
          }
        },
      ),
    );
  }
}
