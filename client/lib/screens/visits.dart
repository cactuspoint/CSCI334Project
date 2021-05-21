import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:client/utils/helpers/database-helper.dart';
import 'package:client/widgets/qrcode-scan.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  bool exposed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Set the location of the visit to be logged:'),
            ElevatedButton(
              child: Text('scan QR code'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRcodeScanWidget()),
                );
              },
            ),
            Text('\nPress -Log Visit- to log your visit:'),
            ElevatedButton(
              child: Text('Log Visit'),
              onPressed: () {
                DatabaseHelper.insertVisit(Visit(
                    DateTime.now().toIso8601String(), globals.currentLocation));
              },
            ),
            Text('\nPress -Exposed?- to check if you have been exposed:'),
            ElevatedButton(
              child: Text('Exposed?'),
              onPressed: () {
                checkExposed();
              },
            ),
            Text('Exposure status: ${exposed.toString()}'),
          ]),
    ));
  }

  checkExposed() async {
    exposed = await DatabaseHelper.exposed();
    setState(() {});
  }
}
