import 'package:flutter/material.dart';
import 'package:client/screens/dashboard.dart';
import 'package:client/utils/helpers/database-helper.dart';
import 'package:client/widgets/qrcode-scan.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  String currentLocation = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text('Alerts'),),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Text('1. Select method to get location:'),
          ElevatedButton(
            child: Text('use QR code'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRcodeScanWidget()),
              );
            },
          ),
          ElevatedButton(
            child: Text('use Device Location'),
            onPressed: () {},
          ),
          Text('2. Press Confirm to log the visit:'),
          ElevatedButton(
            child: Text('Confirm'),
            onPressed: () {
              DatabaseHelper.insertVisit(
                  new Visit(DateTime.now().toIso8601String(), currentLocation));
            },
          ),
        ])));
  }
}
