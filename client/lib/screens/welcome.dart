import 'dart:ui';
import 'package:client/screens/login.dart';
import 'package:client/screens/signup.dart';
import 'package:client/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Align(
                alignment: Alignment.center,
                child: AppIcon(),
              )),
              Column(
                children: [
                  AppName(),
                  SignUpButton(),
                  LogInButton(),
                ],
              ),
            ]),
      ),
    ));
  }
}

class AppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(),
      color: Colors.blueGrey,
      clipBehavior: Clip.antiAlias,
      child: Icon(
        Icons.coronavirus,
        size: 180.0,
        color: Colors.white,
      ),
    );
  }
}

class AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
      child: Text('crossreferenc',
          style: GoogleFonts.odibeeSans(
              fontSize: 50,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600)),
    );
  }
}

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('LOG IN', style: TextStyle(fontSize: 16)))));
  }
}

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: SizedBox(
            width: double.infinity,
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text('SIGN UP', style: TextStyle(fontSize: 16)))));
  }
}
