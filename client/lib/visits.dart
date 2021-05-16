import 'package:flutter/material.dart';
import 'package:client/dashboard.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text('Alerts'),),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
          Text('This is the Visits screen.\n\nLog a visit to a place here\n\n'),
          ElevatedButton(
            child: Text('Scan a QR code'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRViewExample()),
              );
            },
          ),
          ElevatedButton(
            child: Text('Get Device Location'),
            onPressed: () {},
          ),       
        ])));
  }
}

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _buildQRControls(context)),
          Expanded(flex: 2, child: _buildQRViewfinder(context)),
        ],
      ),
    );
  }

  Widget _buildQRControls(BuildContext context) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text('Scan a QR code to log a visit'),
              if (result != null) Text('location=${result.code}'),
              if (result == null) Text('location=NULL'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      dispose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text('Proceed'),
                    onPressed: () {
                      dispose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
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
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
