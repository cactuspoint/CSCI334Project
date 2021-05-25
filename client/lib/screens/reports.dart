import 'package:flutter/material.dart';
import 'package:client/utils/helpers/statistics-helper.dart';

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
                    return Text(snapshot.data);
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
