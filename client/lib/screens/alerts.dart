import 'package:flutter/material.dart';
import 'package:client/utils/helpers/alerts-helper.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: AlertsHelper.alertsWidget());
  }
}
