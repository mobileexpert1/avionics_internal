import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Screens/Games/GamesSubScreens/BlackBoxSection/BlackBoxLockScreen.dart';
import '../../Screens/Games/GamesSubScreens/CalculationSection/CalculationLockScreen.dart';
import '../../Screens/Games/GamesSubScreens/JettingAroundTheWorld/JettingAroundBoardingPassesScreen.dart';
import '../../Screens/Games/GamesSubScreens/OneWordSection/OneWordTopicScreen.dart';
import '../../Screens/Games/GamesSubScreens/QuizSection/QuizLockScreen.dart';
import '../../Screens/Home/RootTabbar/RootTabbarScreen.dart';
import '../../Screens/Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
import '../../Screens/Profile/ProfileMenuScreen/7_AirplaneSection/AirplanePartsScreen.dart';
import '../../Screens/Profile/ProfileMenuScreen/8_Sticker/AllMySticker/AllMyStickerScreen.dart';
import '../../Screens/Profile/ProfileMenuScreen/9_AirmanshipBadges/AirmanshipBadgesScreen.dart';
import '../../bloc/Games/SubGameSection/JettingAroundTheWorld/JettingAroundBoardingPasses/jetting_BoardingPasses_cubit.dart';
import '../AppNavigator.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final screen = response.payload;
        if (screen != null) {
          _handleNotification(screen, navigatorKey: navigatorKey);
        }
      },
    );

    final token = await _messaging.getToken();
    if (token != null) {
      await SharedPrefsHelper.saveFCMToken(token);
    }

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
      _showSnackBar(navigatorKey, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotification(
        message.data['screen'] ?? '',
        navigatorKey: navigatorKey,
      );
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(seconds: 2), () {
        _handleNotification(
          initialMessage.data['screen'] ?? '',
          navigatorKey: navigatorKey,
        );
      });
    }
  }

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

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      notificationDetails: details,
      payload: message.data['screen'],
    );
  }

  static void _showSnackBar(
    GlobalKey<NavigatorState> navigatorKey,
    RemoteMessage message,
  ) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${message.notification?.title ?? ''}: ${message.notification?.body ?? ''}",
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static Future<void> _handleNotification(
    String screen, {
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    Future.delayed(const Duration(milliseconds: 500), () {
      final rootTabState = RootTabbarScreen.globalKey.currentState;
      print("CurrentContext = ${RootTabbarScreen.globalKey.currentContext}");

      print("CurrentState = ${RootTabbarScreen.globalKey.currentState}");
      print("rootTabState-=-=-=-=-=$rootTabState");
      if (rootTabState == null) return;

      int tabIndex;
      Widget? nextScreen;

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
        case 'profiless':
          tabIndex = 4;
          nextScreen = SubscriptionPlanDetailScreen(isComeFromSignup: true);
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
        case 'airmanship_badges':
          tabIndex = 4;
          nextScreen = const AirmanshipBadgesScreen();
          break;
        case 'my_stickers':
          tabIndex = 4;
          nextScreen = const AllMyStickerScreen();
          break;
        case 'my_airplanes':
          tabIndex = 4;
          nextScreen = const AirplanePartsScreen();
          break;
        case 'my_boarding_pass':
          tabIndex = 4;
          nextScreen = const JettingAroundBoardingPassesScreen(
            isComeFromResultScreen: false,
          );
          break;

        default:
          tabIndex = 0;
      }

      rootTabState.onItemTapped(tabIndex);

      if (nextScreen != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (screen.toLowerCase() == 'my_boarding_pass') {
            AppNavigator.push(
              rootTabState.context,
              const JettingAroundBoardingPassesScreen(
                isComeFromResultScreen: false,
              ),
              multiBlocProviders: [
                BlocProvider(create: (_) => JettingBoardingPassCubit()),
              ],
              disableSwipeBack: true,
            );
          } else {
            Navigator.of(
              rootTabState.context,
            ).push(MaterialPageRoute(builder: (_) => nextScreen!));
          }
        });
      }
    });
  }
}
