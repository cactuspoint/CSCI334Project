import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:client/utils/helpers/database-helper.dart';
import 'package:client/widgets/qrcode-scan.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Choose a method to set your location:'),
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
            Text('\nPress Log Visit to log your visit:'),
            ElevatedButton(
              child: Text('Log Visit'),
              onPressed: () {
                DatabaseHelper.insertVisit(new Visit(
                    DateTime.now().toIso8601String(), globals.currentLocation));
              },
            ),
          ]),
    ));
  }
}
