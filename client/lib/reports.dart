import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text('Alerts'),),
        body: Center(
      child: Text('This is the Reports screen.\n\nShow statistics here'),
    ));
  }
}
