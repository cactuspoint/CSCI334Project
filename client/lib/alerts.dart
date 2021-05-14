import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Alerts'),
      // ),
      body: ListView(
        padding: EdgeInsets.only(top: 120),
        children: <Widget>[    
          ListTile(
            title: Text('Alert title 1'),
            subtitle: Text('Fugit praesentium tempora odio voluptatem animi. Laborum cum commodi libero assumenda.', 
            style: TextStyle(
                // fontSize: 16.0,
                height: 1.5,
              ),
            ),
            // trailing: Icon(Icons.tune),
          ),  
          ListTile(
            title: Text('Alert title 2'),
            subtitle: Text('Fugit praesentium tempora odio voluptatem animi. Laborum cum commodi libero assumenda.',
            style: TextStyle(
                // fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),
          ListTile(
            title: Text('Alert title 3'),
            subtitle: Text('Fugit praesentium tempora odio voluptatem animi. Laborum cum commodi libero assumenda.'),
          ),
        ],
      )
    );
  }
}