import 'dart:ui';
import 'welcome.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

void main() {
  runApp(MyApp());
  globals.jwt = "hello";
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
        accentColor: Colors.orangeAccent,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        // visualDensity: VisualDensity(horizontal: 4.0, vertical: 4.0),
        accentColor: Colors.orangeAccent,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
