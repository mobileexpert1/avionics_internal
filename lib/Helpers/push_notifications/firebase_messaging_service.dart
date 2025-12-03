import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    NotificationSettings settings = await _messaging.requestPermission();
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Get the device token
    String? token = await _messaging.getToken();
    print("Device Token: $token");

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Handle messages when the app is opened from the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped on a notification:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
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
    );
  }
}
