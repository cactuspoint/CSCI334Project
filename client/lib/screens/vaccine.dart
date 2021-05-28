import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../utils/constants/app_globals.dart' as globals;

class VaccinePage extends StatefulWidget {
  final String uuid;
  VaccinePage({Key key, @required this.uuid}) : super(key: key);

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
                  variables: {'uuid': widget.uuid, 'jwt': globals.jwt},
                  pollInterval: Duration(seconds: 10),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  print(result.data['person']);
                  var person = result.data['person'];
                  print("test2");
                  int access = globals.access;
                  bool vacinated = !(person['vaccineName'] == "" ||
                      person['vaccineName'] == null);
                  var date;
                  if (vacinated) {
                    date = new DateTime.fromMillisecondsSinceEpoch(
                        person['vaccineDate'] * 1000);
                  }

                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Vaccine certification'),
                    ),
                    body: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (vacinated)
                            Text("Vaccinated with " + person['vaccineName'],
                                textScaleFactor: 1.5),
                          SizedBox(height: 20),
                          if (vacinated)
                            Text(
                                "Vaccines recieved " +
                                    person['vaccineInj'].toString() +
                                    "/" +
                                    person['vaccineRecInj'].toString(),
                                textScaleFactor: 1.5),
                          SizedBox(height: 20),
                          if (vacinated)
                            Text(
                                "Vaccinated on " +
                                    date.year.toString() +
                                    "/" +
                                    date.month.toString() +
                                    "/" +
                                    date.day.toString(),
                                textScaleFactor: 1.5),
                          if (!vacinated)
                            Text("You are not logged as vaccinated yet :(",
                                textScaleFactor: 1.5),
                          if (access >= 3)
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VaccineEditPage(
                                                    uuid: widget.uuid)));
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("Edit",
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.5)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                })));
  }
}

class VaccineEditPage extends StatefulWidget {
  final String uuid;
  VaccineEditPage({Key key, @required this.uuid}) : super(key: key);

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
          if (result.exception.graphqlErrors[0] != null) {
            if (result.exception.graphqlErrors[0].message ==
                "error: user does not have access") {
              _simpleAlert(context, "You does not have access");
            }
          }
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
        firstName,
        lastName,
        vaccineName,
        vaccineInj,
        vaccineRecInj,
        vaccineDate
      }
    }
    ''';
    const String vaccinate = '''
    mutation Vaccinate(\$jwt: String!, \$uuid: String!, \$vaccName: String!, \$vaccDoses: Int!, \$vaccRecommend: Int!){
      action: vaccinate(jwt: \$jwt, uuid:\$uuid, vaccineName: \$vaccName, vaccineInj: \$vaccDoses, vaccineRecInj: \$vaccRecommend) {
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
                variables: {'uuid': widget.uuid, 'jwt': globals.jwt},
                pollInterval: Duration(seconds: 10),
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                var person = result.data['person'];
                return Mutation(
                    options: MutationOptions(
                      document: gql(vaccinate),
                      update: update,
                    ),
                    builder: (RunMutation _vaccinate, QueryResult result) {
                      vaccNameController.text = person['vaccineName'];
                      vaccRecivedController.text =
                          (person['vaccineInj'] != null)
                              ? person['vaccineInj'].toString()
                              : "";
                      vaccRecommendController.text =
                          (person['vaccineRecInj'] != null)
                              ? person['vaccineRecInj'].toString()
                              : "";
                      return Scaffold(
                        appBar: AppBar(
                          title: Text('Edit ' +
                              person['firstName'] +
                              ' ' +
                              person['lastName']),
                        ),
                        body: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("User UUID : " + widget.uuid),
                              SizedBox(height: 20),
                              TextField(
                                keyboardType: TextInputType.name,
                                controller: vaccNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Vaccine Name'),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                keyboardType: TextInputType.phone,
                                controller: vaccRecivedController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Doses Received'),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                keyboardType: TextInputType.phone,
                                controller: vaccRecommendController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Recommended Doses'),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _vaccinate({
                                            'jwt': globals.jwt,
                                            'uuid': widget.uuid,
                                            'vaccName':
                                                (vaccNameController.text !=
                                                        person['vaccineName'])
                                                    ? vaccNameController.text
                                                    : "",
                                            'vaccDoses': int.parse("0" +
                                                vaccRecivedController.text),
                                            'vaccRecommend': int.parse("0" +
                                                vaccRecommendController.text),
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Text("Update"))),
                                  ),
                                  SizedBox(width: 30),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Text("Finish"))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}

class CovidPage extends StatefulWidget {
  final String uuid;
  CovidPage({Key key, @required this.uuid}) : super(key: key);

  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  final vaccNameController = TextEditingController();
  final vaccRecivedController = TextEditingController();
  final vaccRecommendController = TextEditingController();
  OnMutationUpdate get update => (cache, result) {
        if (result.hasException) {
          print(result.exception);
          if (result.exception.graphqlErrors[0] != null) {
            if (result.exception.graphqlErrors[0].message ==
                "error: user does not have access") {
              _simpleAlert(context, "You does not have access");
            }
          }
        } else {
          Navigator.pop(context);
        }
      };

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    const String infect = '''
    mutation infect(\$jwt: String!, \$uuid: String!, \$status: Boolean!){
      action: infect(jwt:\$jwt, uuid:\$uuid, status:\$status) {
        updated
      }
    }
    ''';
    return Scaffold(
        body: SafeArea(
            child: Mutation(
                options: MutationOptions(
                  document: gql(infect),
                  update: update,
                ),
                builder: (RunMutation _infect, QueryResult result) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Set user status'),
                    ),
                    body: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("User UUID : " + widget.uuid),
                          SizedBox(height: 20),
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                isChecked = (!isChecked);
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _infect({
                                        'jwt': globals.jwt,
                                        'uuid': widget.uuid,
                                        'status': isChecked,
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text("Update"))),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text("Finish"))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })));
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
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
