import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A widget that displays a QRcode of a given String at a given size.
///
/// ```dart
/// QRcodeDisplay(String stringToEncode, double size)
/// QRcodeDisplay('Hello World', 200) // Create instance of widget
/// ```
class QRcodeDisplay extends StatelessWidget {
  const QRcodeDisplay(this.data, this.size);
  final String data; // String that is represented by the QRcode
  final double size; // width and height of QRcode in pixels

  @override
  Widget build(BuildContext context) {
    return Container(
      child: QrImage(
        data: data,
        version: QrVersions.auto,
        size: size,
        gapless: false,
      ),
    );
  }
}
