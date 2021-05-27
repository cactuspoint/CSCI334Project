import 'package:flutter/material.dart';
import 'package:client/utils/helpers/statistics-helper.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:convert';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    const String getLogs = '''
    query getLogs(\$backlog: Int!) {
      injectionLog(backLog:\$backlog),
      infectionLog(backLog:\$backlog)
    }
    ''';
    List<String> lines = [];
    return Scaffold(
        body: Center(
            child: FutureBuilder<String>(
                future: StatisticsHelper.getStatistics(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // backing data
                    LineSplitter ls = new LineSplitter();

                    lines += ls.convert(snapshot.data);
                    lines.remove("");
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: lines.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Card(
                                //                           <-- Card widget
                                child: ListTile(
                                  title: Text(lines[index]),
                                ),
                              ));
                        },
                      ),
                    );
                  } else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('loading statistics\n'),
                          CircularProgressIndicator(),
                          Query(
                              options: QueryOptions(
                                document: gql(
                                    getLogs), // this is the query string you just created
                                variables: {'backlog': 1},
                                pollInterval: Duration(seconds: 10),
                              ),
                              builder: (QueryResult result,
                                  {VoidCallback refetch, FetchMore fetchMore}) {
                                print(result);
                                lines.add("App detected cases in past day: " +
                                    result.data['infectionLog'].length
                                        .toString());
                                lines.add(
                                    "App detected injections in past day: " +
                                        result.data['injectionLog'].toString());
                                return Text('\nloaded 1/2');
                              }),
                        ]);
                  }
                })));
  }
}
