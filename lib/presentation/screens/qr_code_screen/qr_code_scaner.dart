import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String scannedValue = 'Tap to scan';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: AiBarcodeScanner(
        cutOutSize: 240,
        hideGalleryButton: true,
        bottomSheetBuilder: (context, controller) {
          return const SizedBox(
            height: 0,
            width: 0,
          );
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) {
          final String? scannedCode = capture.barcodes.first.rawValue;
          print("dfsgvsdfgsdfgvdsfgvsdfgvds ==========$scannedCode");
          if (scannedCode != null) {
            setState(() {
              scannedValue = scannedCode;
              print("QR code detected: $scannedValue");
            });
          }
        },
      ),
    );
  }

  void showDataLoadedDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showDataLoaded(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
