import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:client/utils/helpers/database-helper.dart';
import 'package:client/widgets/qrcode-scan.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
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
            Text('Set the location of the visit to be logged:'),
            SizedBox(height: 10),
            ElevatedButton(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Text('scan QR code')),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRcodeScanWidget()),
                );
              },
            ),
            SizedBox(height: 20),
            Text('\nPress -Log Visit- to log your visit:'),
            SizedBox(height: 10),
            ElevatedButton(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Text('Log Visit')),
              onPressed: () {
                DatabaseHelper.insertVisit(Visit(
                    DateTime.now().toIso8601String().substring(0, 13),
                    globals.currentLocation));
              },
            ),
            SizedBox(height: 20),
            Text('\nPress -Exposed?- to check if you have been exposed:'),
            SizedBox(height: 10),
            Query(
                options: QueryOptions(
                  document: gql(
                      getExposed), // this is the query string you just created
                  variables: {'uuid': "", 'jwt': globals.jwt},
                  pollInterval: Duration(seconds: 10),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  var infectionStatus = "Not currently infected";
                  if (!(result.data['person']['infected'] == "" ||
                      result.data['person']['infected'] == null)) {
                    infectionStatus = "Warning : infected";
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
    setState(() {});
  }
}
