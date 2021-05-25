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
        pfp
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

          String firstName = result.data['person']['firstName'];
          String lastName = result.data['person']['lastName'];
          String pfp = result.data['person']['pfp'];
          return Align(
              alignment: Alignment
                  .topCenter, // This will horizontally center from the top
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill, image: new NetworkImage(pfp)))),
                  SizedBox(height: 30),
                  new Text(firstName + " " + lastName, textScaleFactor: 1.5)
                ],
              ));
        },
      ),
    )));
  }
}
