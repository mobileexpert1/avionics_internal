import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    if (kIsWeb) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      final vapidKey = dotenv.env['FIREBASE_WEB_VAPID_KEY'];

      final token = await _messaging.getToken(vapidKey: vapidKey);
      if (token != null) await SharedPrefsHelper.saveFCMToken(token);

      FirebaseMessaging.onMessage.listen((message) {
        if (navigatorKey?.currentContext != null) {
          ScaffoldMessenger.of(navigatorKey!.currentContext!).showSnackBar(
            SnackBar(
              content: Text(
                "${message.notification?.title ?? 'Notification'} : "
                    "${message.notification?.body ?? ''}",
              ),
            ),
          );
        }
      });
      return;
    }

    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit =
    DarwinInitializationSettings();

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    final token = await _messaging.getToken();
    if (token != null) await SharedPrefsHelper.saveFCMToken(token);

    FirebaseMessaging.onMessage.listen(_showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("Notification tapped");
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
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

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      details,
      payload: message.data['screen'],
    );
  }
}

