import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Analytics'),
        // ),
        body: Center(
            // child: Text('This is the Home view.'),
            child: TextButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Text("logout"),
    )));
  }
}
