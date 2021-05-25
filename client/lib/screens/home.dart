import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../utils/constants/app_globals.dart' as globals;

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
          Color vaccine =
              (person['vaccineName'] == "" || person['vaccineName'] == null)
                  ? Colors.red
                  : Colors.green;
          String vaccine_button = "Not vaccinated";
          print(person);
          return Align(
              alignment: Alignment.topLeft,
              child: new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: new Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 30),
                          new Align(
                              alignment: Alignment.topCenter,
                              child: new Container(
                                  width: 250,
                                  height: 250,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: new NetworkImage(pfp))))),
                          SizedBox(height: 30),
                          new Text(" " + firstName + " " + lastName,
                              textScaleFactor: 1.5),
                          SizedBox(height: 30),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(vaccine)),
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  vaccine_button,
                                  textAlign: TextAlign.left,
                                )),
                            onPressed: () {},
                          ),
                        ],
                      ))));
        },
      ),
    )));
  }
}
