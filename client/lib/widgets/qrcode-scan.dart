import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/// A widget to scan a QRcode with the camera
/// global variable currentLocation is then set by the value of the encoded string
/// ```dart
/// QRcodeScanWidget() // Create the widget
/// ```
class QRcodeScanWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRcodeScanWidgetState();
}

class _QRcodeScanWidgetState extends State<QRcodeScanWidget> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _buildQRViewfinder(context)),
          Expanded(flex: 1, child: _buildQRControls(context)),
        ],
      ),
    );
  }

  Widget _buildQRControls(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Scan a QR code to log a visit'),
        if (result == null) Text('Location is unchanged.'),
        if (result != null) Text('location was set to: ${result.code}'),
        ElevatedButton(
            child: Text('back'),
            onPressed: () {
              dispose();
              Navigator.pop(context, result.code);
            }),
      ],
    );
  }

  Widget _buildQRViewfinder(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        globals.currentLocation = result.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
