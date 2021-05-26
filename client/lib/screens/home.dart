import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/screens/vaccine.dart';
import 'package:flip_card/flip_card.dart';
import 'package:client/widgets/qrcode-display.dart';
import 'package:client/widgets/qrcode-scan.dart';
import 'package:client/utils/constants/app_globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Query(
        options: QueryOptions(
          document: gql(getPerson), // this is the query string you just created
          variables: {'uuid': "", 'jwt': globals.jwt},
          pollInterval: Duration(seconds: 10),
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Text('Loading');
          }
          var person = result.data['person'];
          String firstName = person['firstName'];
          String lastName = person['lastName'];
          String pfp = person['pfp'];
          bool vaccinated =
              !(person['vaccineName'] == "" || person['vaccineName'] == null);
          Color qrColor =
              (MediaQuery.of(context).platformBrightness == Brightness.dark)
                  ? Colors.white
                  : Colors.black;
          String vaccine_button = "Not vaccinated";
          globals.access = person['access'] != null ? person['access'] : 0;
          print(person);
          return Align(
              alignment: Alignment.topLeft,
              child: new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: new Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          new Align(
                            alignment: Alignment.topCenter,
                            child: new FlipCard(
                              direction: FlipDirection.HORIZONTAL,
                              front: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: new Container(
                                        width: 250,
                                        height: 250,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: new NetworkImage(pfp)))),
                                  ),
                                ],
                              ),
                              back: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: QRcodeDisplay(
                                        person['uuid'], 250, qrColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          new Text(" " + firstName + " " + lastName,
                              textScaleFactor: 1.5),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    vaccinated ? Colors.green : Colors.red)),
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  vaccinated
                                      ? "Vaccinated with " +
                                          person['vaccineName']
                                      : "Not Vaccinated",
                                  textAlign: TextAlign.left,
                                )),
                            onPressed: () {
                              if (vaccinated || globals.access >= 3) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VaccinePage(uuid: person['uuid'])));
                              }
                            },
                          ),
                          SizedBox(height: 30),
                          if (globals.access >= 1)
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.pink[200])),
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.0),
                                  child: Text("Verify another user")),
                              onPressed: () {
                                _scanPerson(context);
                              },
                            ),
                        ],
                      ))));
        },
      ),
    )));
  }

  void _scanPerson(BuildContext context) async {
    var text = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QRcodeScanWidget()));
    if (text.length == 36) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => VaccinePage(uuid: text)));
    }
  }
}
