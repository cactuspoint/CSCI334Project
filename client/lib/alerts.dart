import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text('Alerts'),),
        body: ListView(
      padding: EdgeInsets.only(top: 120),
      children: <Widget>[
        ListTile(
          title: Text('Example Alert 1 title'),
          subtitle: Text(
            'Example Text.',
          ),
        ),
        ListTile(
          title: Text('Example Alert 2 title'),
          subtitle: Text(
              'Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text. Long example text.'),
        ),
      ],
    ));
  }
}
