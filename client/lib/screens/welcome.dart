import 'dart:ui';
import 'package:client/screens/login.dart';
import 'package:client/screens/signup.dart';
import 'package:client/screens/dashboard.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SignUpButton(),
              LogInButton(),
            ]),
        floatingActionButton: BypassLoginButton());
  }
}

class LogInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
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
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
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

class BypassLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardPage()))
            },
        tooltip: "Bypass Login",
        child: Icon(Icons.login));
  }
}
