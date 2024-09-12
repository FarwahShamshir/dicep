// services/notification_services.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationServices() {
    initLocalNotifications();
  }

  // Initialize Local Notifications
  void initLocalNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        // Handle notification tap here if needed
        print('Notification tapped: ${notificationResponse.payload}');
      },
    );
  }

  // Show a local notification
  Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_id',
      'High Importance Notifications',
      channelDescription: 'This channel is for important notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }
}
