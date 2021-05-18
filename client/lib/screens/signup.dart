import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/screens/dashboard.dart';
import '../utils/constants/app_globals.dart' as globals;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  OnMutationUpdate get update => (cache, result) {
        bool showDash = true;
        if (result.hasException) {
          print(result.exception);
          if (result.exception.graphqlErrors[0] != null) {
            if (result.exception.graphqlErrors[0].message ==
                "error: user already exists") {
              passController.text = "";
              showDash = false;
              Navigator.pop(context);
              _simpleAlert(
                  context, "Error user already exists with that phone number");
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
  final passControllerBk = TextEditingController();
  final fNController = TextEditingController();
  final lNController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const String signup = '''
    mutation SignUp(\$phoneNum: String!, \$password: String!, \$firstName: String!, \$lastName: String!) {
      action: signUp(phoneNum: \$phoneNum, password: \$password, firstName: \$firstName, lastName: \$lastName){
        accessToken
      }
    }
    ''';

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // padding: EdgeInsets.only(left: 8),
                // child: Text('Log in'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Create an account',
                      style: TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // alignment: Alignment.center,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile number',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // alignment: Alignment.center,
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                // padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // alignment: Alignment.center,
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passControllerBk,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                // padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // alignment: Alignment.center,
                child: TextField(
                  controller: fNController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                // padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                // alignment: Alignment.center,
                child: TextField(
                  controller: lNController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                ),
              ),
            ),
            Spacer(),
            Flexible(
              child: Container(
                // padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  // width: double.infinity,
                  child: Mutation(
                      options: MutationOptions(
                        document: gql(signup),
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
                              if (passController.text == passControllerBk.text) {
                                _authenticate({
                                  'phoneNum': phoneController.text,
                                  'password': passController.text,
                                  'firstName': fNController.text,
                                  'lastName': lNController.text,
                                });
                              } else {
                                passController.text = "";
                                passControllerBk.text = "";
                                _simpleAlert(context, "Passwords don't match");
                              }
                            },
                            child: Text(
                              'SIGNUP',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                ),
              ),
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
