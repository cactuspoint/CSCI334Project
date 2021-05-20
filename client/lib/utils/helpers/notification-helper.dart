import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

/// A helper class to generate a native notification.
/// ```dart
/// NotificationHelper.generateNotification("Example Title", "Example body");
/// ```
class NotificationHelper {
  static Future<void> setup() {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: 'default_channel',
          channelName: 'notifications',
          channelDescription: 'default notification channel',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> openListeningStream() {
    AwesomeNotifications().actionStream.listen((receivedNotification) {});
  }

  static Future<void> generateNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10, channelKey: 'default_channel', title: title, body: body),
    );
  }

  static Future<void> unreadAlertNotification() {
    generateNotification(
      "You have an unread alert",
      "An unread alert is waiting for you in the app.",
    );
  }
}
