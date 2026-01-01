import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings =
    InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(settings);
  }

  static Future<void> show({
    required String title,
    required String body,
    String? screenName,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'local_channel',
      'Local Notifications',
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

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: screenName,
    );
  }
}
