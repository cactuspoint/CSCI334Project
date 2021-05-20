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
        lastName
      }
    }
    ''';
    return Scaffold(
      body: Center(
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

          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              // final repository = repositories[index];

              return Text(
                "Hello, " + firstName + " " + lastName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                );
            },
          );
        },
      )),
    );
  }
}
