import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (Barcode barcode, MobileScannerArguments? args) {
        Navigator.pop(context,barcode.rawValue);
      },
    );
  }
}
