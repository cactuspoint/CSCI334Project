import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:client/utils/helpers/database-helper.dart';
import 'package:client/widgets/qrcode-scan.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/utils/helpers/notification-helper.dart';
import 'package:client/utils/helpers/alerts-helper.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  int _index = 0;
  bool exposed = false;

  @override
  Widget build(BuildContext context) {
    const String getExposed = '''
    query GetPerson(\$uuid: String!, \$jwt: String!) {
      person(uuid: \$uuid, jwt: \$jwt) {
        infected
      }
    }
    ''';
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Query(
                options: QueryOptions(
                  document: gql(
                      getExposed), // this is the query string you just created
                  variables: {'uuid': "", 'jwt': globals.jwt},
                  pollInterval: Duration(seconds: 10),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  var infectionStatus =
                      "Infection Status: Not Currently Infected";
                  if (!(result.data['person']['infected'] == "" ||
                      result.data['person']['infected'] == null)) {
                    infectionStatus = "Infection Status: Currently Infected ";
                  }
                  return ElevatedButton(
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        child: Text(infectionStatus)),
                    onPressed: () {
                      refetch();
                    },
                  );
                }),
            SizedBox(height: 10),
            ElevatedButton(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exposed == false)
                        Text("Exposure Status: No Known Exposure"),
                      if (exposed == true)
                        Text("Exposure Status: Possible Exposure"),
                    ],
                  )),
              onPressed: () {
                checkExposed();
              },
            ),
            // SizedBox(height: 10),
            Text('\nTap a Status to check for updates'),
            SizedBox(height: 30),
            Stepper(
              currentStep: _index,
              onStepCancel: () {
                if (_index > 0) {
                  setState(() {
                    _index -= 1;
                  });
                }
              },
              onStepContinue: () {
                if (_index <= 0) {
                  setState(() {
                    _index += 1;
                  });
                }
              },
              onStepTapped: (int index) {
                setState(() {
                  _index = index;
                });
              },
              steps: <Step>[
                Step(
                  title: const Text('Set Visit Location'),
                  content: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Scan a QR code to set your location.\n'),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRcodeScanWidget()),
                              );
                            },
                            child: Text('Launch QRcode Scanner'))
                      ],
                    ),
                  ),
                  isActive: _index >= 0,
                  state: _index >= 1 ? StepState.complete : StepState.disabled,
                ),
                Step(
                  title: Text('Log the Visit'),
                  content: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Are you sure you want to log the Visit?.\n'),
                          OutlinedButton(
                              onPressed: () {
                                DatabaseHelper.insertVisit(Visit(
                                    DateTime.now()
                                        .toIso8601String()
                                        .substring(0, 13),
                                    globals.currentLocation));
                              },
                              child: Text('Confirm Log Visit'))
                        ],
                      )),
                  isActive: _index >= 1,
                  state: _index >= 2 ? StepState.complete : StepState.disabled,
                ),
              ],
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      if (_index == 0)
                        RaisedButton.icon(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: onStepContinue,
                          label: Text('CONTINUE'),
                          color: Colors.blue,
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_index == 1)
                            RaisedButton.icon(
                              icon: Icon(Icons.arrow_back_ios),
                              label: const Text('BACK'),
                              onPressed: onStepCancel,
                            ),
                          if (_index == 1)
                            RaisedButton.icon(
                              icon: Icon(Icons.exposure_plus_1),
                              label: const Text('START NEW VISIT'),
                              onPressed: onStepCancel,
                              color: Colors.green,
                            )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ]),
    )));
  }

  checkExposed() async {
    const String getPerson = '''
    query GetPerson(\$uuid: String!, \$jwt: String!) {
      person(uuid: \$uuid, jwt: \$jwt) {
        uuid,
        phoneNum,
        firstName,
        lastName,
        pfp,
        vaccineName,
        access,
      }
    }
    ''';
    exposed = await DatabaseHelper.exposed();
    if (exposed == true) {
      AlertsHelper.addExposureAlert();
      NotificationHelper.generateNotification(
          "Possible Exposure Event Detected!",
          "It is recommended that you get tested");
    }
    setState(() {});
  }
}
