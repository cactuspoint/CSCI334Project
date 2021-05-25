import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../utils/constants/app_globals.dart' as globals;

class VaccinePage extends StatefulWidget {
  @override
  _VaccinePageState createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  @override
  Widget build(BuildContext context) {
    const String getPerson = '''
    query GetPerson(\$uuid: String!, \$jwt: String!) {
      person(uuid: \$uuid, jwt: \$jwt) {
        uuid,
        access,
        vaccineName,
        vaccineInj,
        vaccineRecInj,
        vaccineDate
      }
    }
    ''';
    return Scaffold(
        body: SafeArea(
            child: Query(
                options: QueryOptions(
                  document: gql(
                      getPerson), // this is the query string you just created
                  variables: {'uuid': "", 'jwt': globals.jwt},
                  pollInterval: Duration(seconds: 10),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  var person = result.data['person'];
                  int access = person['access'];
                  bool vacinated = !(person['vaccineName'] == "" ||
                      person['vaccineName'] == null);
                  var date = new DateTime.fromMillisecondsSinceEpoch(
                      person['vaccineDate'] * 1000);
                  return Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("<< back")),
                      if (vacinated)
                        Text("Vaccinated with" + person['vaccineName']),
                      if (vacinated)
                        Text(
                            "vaccines recieved " +
                                person['vaccineInj'].toString() +
                                "/" +
                                person['vaccineRecInj'].toString(),
                            textScaleFactor: 1.5),
                      if (vacinated)
                        Text(
                            "vaccinated on " +
                                date.year.toString() +
                                "/" +
                                date.month.toString() +
                                "/" +
                                date.day.toString(),
                            textScaleFactor: 1.5),
                      if (access >= 3)
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VaccineEditPage()));
                            },
                            child: Text("Edit")),
                    ],
                  );
                })));
  }
}

class VaccineEditPage extends StatefulWidget {
  @override
  _VaccineEditPageState createState() => _VaccineEditPageState();
}

class _VaccineEditPageState extends State<VaccineEditPage> {
  final vaccNameController = TextEditingController();
  final vaccRecivedController = TextEditingController();
  final vaccRecommendController = TextEditingController();

  OnMutationUpdate get update => (cache, result) {
        if (result.hasException) {
          print(result.exception);
          // if (result.exception.graphqlErrors[0] != null) {
          //   if (result.exception.graphqlErrors[0].message ==
          //       "error: incorrect password") {
          //     passController.text = "";
          //     _simpleAlert(context, "Incorrect password");
          //   } else if (result.exception.graphqlErrors[0].message ==
          //       "error: incorrect phoneNum") {
          //     phoneController.text = "";
          //     _simpleAlert(context, "Incorrect phone number");
          //   }
          // }
        } else {
          Navigator.pop(context);
        }
      };

  @override
  Widget build(BuildContext context) {
    const String getPerson = '''
    query GetPerson(\$uuid: String!, \$jwt: String!) {
      person(uuid: \$uuid, jwt: \$jwt) {
        uuid,
        access,
        vaccineName,
        vaccineInj,
        vaccineRecInj,
        vaccineDate
      }
    }
    ''';
    const String vaccinate = '''
    mutation Vaccinate(\$uuid: String!, \$vaccName: String!, \$vaccDoses: Int!, \$vaccRecommend: Int!){
      action: vaccinate(uuid:\$uuid, vaccineName: \$vaccName, vaccineInj: \$vaccDoses, vaccineRecInj: \$vaccRecommend) {
        updated
      }
    }
    ''';
    return Scaffold(
      body: SafeArea(
          child: Query(
              options: QueryOptions(
                document:
                    gql(getPerson), // this is the query string you just created
                variables: {'uuid': "", 'jwt': globals.jwt},
                pollInterval: Duration(seconds: 10),
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                var person = result.data['person'];
                int access = person['access'];
                bool vacinated = !(person['vaccineName'] == "" ||
                    person['vaccineName'] == null);
                return Mutation(
                    options: MutationOptions(
                      document: gql(vaccinate),
                      update: update,
                    ),
                    builder: (RunMutation _vaccinate, QueryResult result) {
                      return Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: vaccNameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Vaccine Name'),
                          ),
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: vaccRecivedController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Doses Received'),
                          ),
                          TextField(
                            keyboardType: TextInputType.phone,
                            controller: vaccRecommendController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Recommended Doses'),
                          ),
                          if (access >= 3)
                            ElevatedButton(
                                onPressed: () {
                                  _vaccinate({
                                    'uuid': person['uuid'],
                                    'vaccName': vaccNameController.text,
                                    'vaccDoses': int.parse(
                                        "0" + vaccRecivedController.text),
                                    'vaccRecommend': int.parse(
                                        "0" + vaccRecommendController.text),
                                  });
                                },
                                child: Text("Update")),
                          if (access >= 3)
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Discard")),
                        ],
                      );
                    });
              })),
    );
  }
}
