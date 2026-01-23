import 'package:avionics_internal/Screens/Games/GamesSubScreens/BlackBoxSection/BlackBoxLockScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/CalculationSection/CalculationLockScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/OneWordSection/OneWordTopicScreen.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizLockScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import '../../Screens/Onboarding/Subscription/AppleSubscription/AppleSubscriptionScreen.dart';
import '../../Screens/Profile/GameBadges/BadgesScreens.dart';
//import 'local_notification_storage.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize({required GlobalKey<NavigatorState> navigatorKey}) async {
    // Request permissions
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Local notifications setup
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final screen = response.payload;
        if (screen != null) {
          _handleNotification(screen, navigatorKey: navigatorKey);
        }
      },
    );

    // Save FCM token
    final token = await _messaging.getToken();
    if (token != null) await SharedPrefsHelper.saveFCMToken(token);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
      _showSnackBar(navigatorKey, message);
    });

    // Handle background / user taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotification(
        message.data['screen'] ?? '',
        title: message.notification?.title,
        body: message.notification?.body,
        navigatorKey: navigatorKey,
      );
    });

    // Handle terminated app launch
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 3), () {
        _handleNotification(
          initialMessage.data['screen'] ?? '',
          title: initialMessage.notification?.title,
          body: initialMessage.notification?.body,
          navigatorKey: navigatorKey,
        );
      });
    }
  }

  /// Show local notification
  static Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_priority_channel',
      'High Priority',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      details,
      payload: message.data['screen'],
    );
  }

  /// Show SnackBar
  static void _showSnackBar(GlobalKey<NavigatorState> navigatorKey, RemoteMessage message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            "${message.notification?.title ?? 'Notification'}: ${message.notification?.body ?? ''}",
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Handle tab switch + sub-screen navigation
  static Future<void> _handleNotification(
      String screen, {
        String? title,
        String? body,
        GlobalKey<NavigatorState>? navigatorKey,
      }) async {

    // Delay to ensure RootTabbarscreen is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      final rootTabState = RootTabbarscreen.globalKey.currentState;
      if (rootTabState == null) return;

      int tabIndex;
      Widget? nextScreen;

      // Determine tab index
      switch (screen.toLowerCase()) {
        case 'home':
          tabIndex = 0;
          break;
        case 'trackflight':
          tabIndex = 1;
          break;
        case 'games':
          tabIndex = 2;
          break;
        case 'askwilco':
          tabIndex = 3;
          break;
        case 'profile':
          tabIndex = 4;
          break;
        case 'profiless': // Subscription
          tabIndex = 4;
          nextScreen = AppleSubscriptionScreen(isComeFromSignup: false);
          break;
        case 'badgess_quiz':
          tabIndex = 2;
          nextScreen = const QuizLockScreen();
          break;
        case 'badgess_oneword':
          tabIndex = 2;
           nextScreen = const OneWordTopicScreen();
          break;
        case 'badgess_black':
          tabIndex = 2;
          nextScreen = const BlackBoxLockScreen();
          break;
        case 'badgess_calculation':
          tabIndex = 2;
          nextScreen = const CalculationLockScreen();
          break;
        default:
          tabIndex = 0;
      }

      // Switch tab
      rootTabState.onItemTapped(tabIndex);

      // Push sub-screen if exists
      if (nextScreen != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(rootTabState.context).push(
            MaterialPageRoute(builder: (_) => nextScreen!),
          );
        });
      }
    });
  }
}
