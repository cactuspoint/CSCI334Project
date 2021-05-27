import 'package:flutter/material.dart';
import 'package:client/utils/helpers/statistics-helper.dart';
import 'dart:convert';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<String>(
                future: StatisticsHelper.getStatistics(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // backing data
                    LineSplitter ls = new LineSplitter();

                    List<String> lines = ls.convert(snapshot.data);
                    lines.removeAt(0);
                    return ListView.builder(
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        return Card(
                          //                           <-- Card widget
                          child: ListTile(
                            title: Text(lines[index]),
                          ),
                        );
                      },
                    );
                  } else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('loading statistics\n'),
                          CircularProgressIndicator()
                        ]);
                  }
                })));
  }
}
