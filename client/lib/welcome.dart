import 'dart:ui';

import 'login.dart';
import 'signup.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text('COVID Alert'),
      //   ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.,
          //   // padding: EdgeInsets.fromLTRB(16, 24, 8, 480),
          //   // padding: EdgeInsets.only(left: 8),
          //   // child: Text('Log in'),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         'COVID Alert',
          //         style: TextStyle(fontSize: 32),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
            // padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 16,
                    // color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
            // padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  // primary: Colors.orangeAccent,
                  // onPrimary: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},

      // ),
    );
  }
}
