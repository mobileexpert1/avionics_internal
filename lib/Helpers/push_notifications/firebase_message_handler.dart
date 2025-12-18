import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (kIsWeb) return;

  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'high_priority_channel',
    'High Priority',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosDetails =
  DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails details =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  await FlutterLocalNotificationsPlugin().show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Notification',
    message.notification?.body ?? '',
    details,
    payload: message.data['screen'],
  );
}
