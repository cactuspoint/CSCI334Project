import 'package:client/utils/constants/app_globals.dart' as globals;
import 'package:flutter/material.dart';

/// A helper class to manage alerts widget.
class AlertsHelper {
  static alertsWidget() {
    if (globals.alerts == null)
      return Text("You have no alerts.");
    else
      return ListView.builder(
        itemCount: globals.alerts.length,
        itemBuilder: (context, index) {
          final item = globals.alerts[index];
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
          );
        },
      );
  }

  static setup() {}

  static addExposureAlert() {
    // debug: create example alert
    globals.alerts = List<ListItem>.generate(
        1,
        (i) => ListItem("Possible Exposure Event Detected!",
            "It is recommended that you get tested"));
  }
}

class ListItem {
  final String sender;
  final String body;
  ListItem(this.sender, this.body);
  Widget buildTitle(BuildContext context) => Text(sender);
  Widget buildSubtitle(BuildContext context) => Text(body);
}
