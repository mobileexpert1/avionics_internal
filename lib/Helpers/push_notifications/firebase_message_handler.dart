import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("Handling a background message:");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id', // Channel ID
    'channel_name', // Channel name
    channelDescription: 'channel_description', // Channel description
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
  NotificationDetails(android: androidDetails);

  await _flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    platformDetails,
    payload: message.data['screen'],
  );
}
