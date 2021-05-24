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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
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

                      return Text("Hello, \n" + firstName + " " + lastName,
                        style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400),
                      );

                      // return ListView.builder(
                      //   itemCount: 1,
                      //   itemBuilder: (context, index) {
                      //     // final repository = repositories[index];

                      //     return Text(
                      //       "Hello, \n" + firstName + " " + lastName,
                      //         style: TextStyle(
                      //           fontSize: 32,
                      //           fontWeight: FontWeight.w400),
                      //       );
                      //   },
                      // );
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      // tapping the icon will open an ImagePicker
                    },
                    child: Material(
                      elevation: 4.0,
                      shape: CircleBorder(),
                      color: Colors.blueGrey,
                      clipBehavior: Clip.antiAlias,
                      child: Icon(
                        Icons.account_circle,
                        size: 180.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Flexible widget for the vaccination status

              // Flexible(
              //   flex: 3,
              //   child: Container(
              //     width: double.infinity,
              //     alignment: Alignment.topLeft,
              //     child: Text('Vaccination status',
              //       style: TextStyle(
              //       fontSize: 26,
              //       fontWeight: FontWeight.w400),
              //     ),
              //   ),
              // ),
            ],
          ),
          )),
    );
  }
}
