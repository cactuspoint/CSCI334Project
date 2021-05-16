import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dashboard.dart';
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  OnMutationUpdate get update => (cache, result) {
        bool showDash = true;
        if (result.hasException) {
          print(result.exception);
          if (result.exception.graphqlErrors[0] != null) {
            if (result.exception.graphqlErrors[0].message ==
                "error: incorrect password") {
              passController.text = "";
              showDash = false;
              _simpleAlert(context, "Incorrect password");
            } else if (result.exception.graphqlErrors[0].message ==
                "error: incorrect phoneNum") {
              phoneController.text = "";
              showDash = false;
              _simpleAlert(context, "Incorrect phone number");
            }
          }
          if (showDash) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardPage()));
          }
        } else {
          globals.jwt = result.data['action']['accessToken'].toString();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        }
      };

  final phoneController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const String authenticate = '''
    mutation Authenticate(\$phoneNum: String!, \$password: String!){
      action: auth(phoneNum: \$phoneNum, password: \$password){
        accessToken
      }
    }
    ''';

    return Scaffold(
      // appBar: AppBar(
      //     title: Text('COVID Alert'),
      //   ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 64),
            // padding: EdgeInsets.only(left: 8),
            // child: Text('Log in'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Have an account?',
                  style: TextStyle(fontSize: 32),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            alignment: Alignment.center,
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile number',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
            alignment: Alignment.center,
            child: TextField(
              controller: passController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
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
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
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
            child: Mutation(
                options: MutationOptions(
                  document: gql(authenticate),
                  update: update,
                  // onError: (OperationException error) =>
                  //     _simpleAlert(context, error.toString()),
                ),
                builder: (RunMutation _authenticate, QueryResult result) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () {
                        _authenticate({
                          'phoneNum': phoneController.text,
                          'password': passController.text
                        });
                      },
                      child: Text(
                        'LOG IN',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

void _simpleAlert(BuildContext context, String text) => showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: <Widget>[
            SimpleDialogOption(
              child: const Text('DISMISS'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
