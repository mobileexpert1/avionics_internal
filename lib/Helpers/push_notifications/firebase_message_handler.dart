// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> backgroundMessageHandler(RemoteMessage message) async {
//   print("Handling a background message:");
//   print("Title: ${message.notification?.title}");
//   print("Body: ${message.notification?.body}");
//
//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'channel_id', // Channel ID
//     'channel_name', // Channel name
//     channelDescription: 'channel_description', // Channel description
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//
//   const NotificationDetails platformDetails =
//   NotificationDetails(android: androidDetails);
//
//   await _flutterLocalNotificationsPlugin.show(
//     message.hashCode,
//     message.notification?.title,
//     message.notification?.body,
//     platformDetails,
//     payload: message.data['screen'],
//   );
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global plugin initialization
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("Background message received:");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: iosSettings,
  );

  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await _flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    platformDetails,
    payload: message.data['screen'],
  );
}
