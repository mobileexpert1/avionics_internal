// // import 'dart:io';
// //
// // import 'package:anywaydrive/core/constants/color_constants.dart';
// // import 'package:anywaydrive/core/constants/fonts.dart';
// // import 'package:anywaydrive/core/utils/extensions/context.l10n.dart';
// // import 'package:anywaydrive/core/widgets/large_text.dart';
// // import 'package:anywaydrive/core/widgets/medium_text.dart';
// // import 'package:anywaydrive/src/presentation/screens/notification/bloc/notification_bloc.dart';
// // import 'package:anywaydrive/src/presentation/screens/notification/bloc/notification_event.dart';
// // import 'package:anywaydrive/src/presentation/screens/notification/model/app_notification_model.dart';
// // import 'package:anywaydrive/core/utils/services/store_services.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // class FirebaseNotificationService {
// //   final NotificationBloc notificationBloc;
// //
// //   static final FlutterLocalNotificationsPlugin
// //   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// //
// //   FirebaseNotificationService(this.notificationBloc);
// //
// //   Future<void> initialize() async {
// //     await Firebase.initializeApp();
// //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// //     _initializeLocalNotifications();
// //
// //     // Get FCM token and save it
// //     await _getFCMToken();
// //
// //     // Check if push notifications are enabled and subscribe accordingly
// //     final isPushEnabled = await StoreServices.isEnabled();
// //     if (isPushEnabled) {
// //       await subscribeToNotifications();
// //     }
// //
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
// //       // Check if push notifications are enabled in settings
// //       final isPushEnabled = await StoreServices.isEnabled();
// //       if (!isPushEnabled) {
// //         print("Push notifications disabled in settings, ignoring message");
// //         return;
// //       }
// //
// //       RemoteNotification? notification = message.notification;
// //       AndroidNotification? android = message.notification?.android;
// //       if (notification != null && android != null) {
// //         showNotification(
// //           id: notification.hashCode,
// //           title: notification.title,
// //           body: notification.body,
// //         );
// //
// //         final notif = AppNotificationModel(
// //           title: notification.title ?? "No Title",
// //           body: notification.body ?? "No Body",
// //           timestamp: DateTime.now(),
// //         );
// //         notificationBloc.add(AddNotification(notif));
// //       }
// //     });
// //   }
// //
// //   Future<void> _getFCMToken() async {
// //     try {
// //       final token = await FirebaseMessaging.instance.getToken();
// //       if (token != null) {
// //         await StoreServices.saveFcmToken(token);
// //         print("FCM Token: $token");
// //       }
// //     } catch (e) {
// //       print("Error getting FCM token: $e");
// //     }
// //   }
// //
// //   static Future<void> subscribeToNotifications() async {
// //     try {
// //       final token = await FirebaseMessaging.instance.getToken();
// //       if (token != null) {
// //         // Subscribe to a general topic for notifications
// //         await FirebaseMessaging.instance.subscribeToTopic('notifications');
// //         print("Subscribed to notifications topic");
// //       }
// //     } catch (e) {
// //       print("Error subscribing to notifications: $e");
// //     }
// //   }
// //
// //   static Future<void> unsubscribeFromNotifications() async {
// //     try {
// //       // Unsubscribe from the general topic for notifications
// //       await FirebaseMessaging.instance.unsubscribeFromTopic('notifications');
// //       print("Unsubscribed from notifications topic");
// //     } catch (e) {
// //       print("Error unsubscribing from notifications: $e");
// //     }
// //   }
// //
// //   static void _initializeLocalNotifications() {
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('background');
// //     final InitializationSettings initializationSettings =
// //         InitializationSettings(android: initializationSettingsAndroid);
// //
// //     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
// //   }
// //
// //   static Future<void> _firebaseMessagingBackgroundHandler(
// //     RemoteMessage message,
// //   ) async {
// //     await Firebase.initializeApp();
// //
// //     // Check if push notifications are enabled in settings
// //     final isPushEnabled = await StoreServices.isEnabled();
// //     if (!isPushEnabled) {
// //       print(
// //         "Push notifications disabled in settings, ignoring background message",
// //       );
// //       return;
// //     }
// //
// //     print("Handling a background message: ${message.messageId}");
// //   }
// //
// //   static Future<void> showNotification({
// //     required int id,
// //     required String? title,
// //     required String? body,
// //   }) async {
// //     const androidDetails = AndroidNotificationDetails(
// //       'default_channel_id',
// //       'Default',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       icon: 'ic_notification',
// //     );
// //
// //     const notificationDetails = NotificationDetails(android: androidDetails);
// //
// //     await _flutterLocalNotificationsPlugin.show(
// //       id,
// //       title,
// //       body,
// //       notificationDetails,
// //     );
// //   }
// // }
// //
// // Future<void> requestNotificationPermission(BuildContext context) async {
// //   if (Platform.isAndroid) {
// //     // Android 13+ requires runtime permission
// //     if (await Permission.notification.isDenied) {
// //       final status = await Permission.notification.request();
// //       if (status.isGranted) {
// //         print("✅ Notification permission granted (Android)");
// //       } else {
// //         print("❌ Notification permission denied (Android)");
// //         _showPermissionDialog(context);
// //       }
// //     }
// //   } else if (Platform.isIOS) {
// //     final status = await Permission.notification.request();
// //     if (status.isGranted) {
// //       print("✅ Notification permission granted (iOS)");
// //     } else {
// //       print("❌ Notification permission denied (iOS)");
// //       _showPermissionDialog(context);
// //     }
// //   }
// // }
// //
// //
// // void _showPermissionDialog(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder:
// //         (_) => AlertDialog(
// //           title: LargeText(text: context.l10n.notificationPermission, fontSize: 22,),
// //           content:
// //           LargeText(text: context.l10n.enableNotifications),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 openAppSettings();
// //                 Navigator.of(context).pop();
// //               },
// //               child:  Text(
// //                 context.l10n.openSettings,
// //                 style: TextStyle(
// //                   //textAlign: TextAlign.center,
// //                   fontSize: 16,
// //                   fontFamily: Fonts.urbanistRegular,
// //                   fontWeight: FontWeight.w400,
// //                   color: ColorConstants.greyDarkColor,
// //                 ),
// //               ),
// //             ),
// //
// //             MediumText(
// //               text: context.l10n.cancel,
// //               //  textAlign: TextAlign.center,
// //               fontSize: 16,
// //               fontFamily: Fonts.urbanistRegular,
// //               fontWeight: FontWeight.w400,
// //               color: ColorConstants.greyDarkColor,
// //             ),
// //           ],
// //         ),
// //   );
// // }
//
//
//
// import 'dart:io';
// import 'package:anywaydrive/core/constants/color_constants.dart';
// import 'package:anywaydrive/core/constants/fonts.dart';
// import 'package:anywaydrive/core/utils/extensions/context.l10n.dart';
// import 'package:anywaydrive/core/widgets/large_text.dart';
// import 'package:anywaydrive/core/widgets/medium_text.dart';
// import 'package:anywaydrive/src/presentation/screens/notification/bloc/notification_bloc.dart';
// import 'package:anywaydrive/src/presentation/screens/notification/bloc/notification_event.dart';
// import 'package:anywaydrive/src/presentation/screens/notification/model/app_notification_model.dart';
// import 'package:anywaydrive/core/utils/services/store_services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class FirebaseNotificationService {
//   final NotificationBloc notificationBloc;
//
//   static final FlutterLocalNotificationsPlugin
//   _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   FirebaseNotificationService(this.notificationBloc);
//
//   /// Initialize Firebase, messaging, and local notifications
//   Future<void> initialize() async {
//     await Firebase.initializeApp();
//
//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // Initialize local notifications
//     _initializeLocalNotifications();
//
//     // iOS: Ensure presentation options are allowed while app is in foreground
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Request permission before getting token (especially for iOS)
//     await _requestFirebasePermission();
//
//     // Get FCM token and save it
//     await _getFCMToken();
//
//     // Subscribe if notifications are enabled in settings
//     final isPushEnabled = await StoreServices.isEnabled();
//     if (isPushEnabled) {
//       await subscribeToNotifications();
//     }
//
//     // Foreground message listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       final isPushEnabled = await StoreServices.isEnabled();
//       if (!isPushEnabled) {
//         print("🚫 Push notifications disabled in settings, ignoring message");
//         return;
//       }
//
//       final notification = message.notification;
//       if (notification != null) {
//         await showNotification(
//           id: notification.hashCode,
//           title: notification.title,
//           body: notification.body,
//         );
//
//         // Add to app’s notification list via bloc
//         final notif = AppNotificationModel(
//           title: notification.title ?? "No Title",
//           body: notification.body ?? "No Body",
//           timestamp: DateTime.now(),
//         );
//         notificationBloc.add(AddNotification(notif));
//       }
//     });
//   }
//
//   /// Get and store FCM token
//   Future<void> _getFCMToken() async {
//     try {
//       final token = await FirebaseMessaging.instance.getToken();
//       if (token != null) {
//         await StoreServices.saveFcmToken(token);
//         print("📱 FCM Token: $token");
//       }
//     } catch (e) {
//       print("❌ Error getting FCM token: $e");
//     }
//   }
//
//   /// Subscribe to a topic for global notifications
//   static Future<void> subscribeToNotifications() async {
//     try {
//       await FirebaseMessaging.instance.subscribeToTopic('notifications');
//       print("✅ Subscribed to notifications topic");
//     } catch (e) {
//       print("❌ Error subscribing to notifications: $e");
//     }
//   }
//
//   /// Unsubscribe from topic
//   static Future<void> unsubscribeFromNotifications() async {
//     try {
//       await FirebaseMessaging.instance.unsubscribeFromTopic('notifications');
//       print("🚫 Unsubscribed from notifications topic");
//     } catch (e) {
//       print("❌ Error unsubscribing from notifications: $e");
//     }
//   }
//
//   /// Initialize local notifications (Android + iOS)
//   static void _initializeLocalNotifications() {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('background');
//
//     const DarwinInitializationSettings initializationSettingsDarwin =
//     DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   /// Background FCM message handler
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     final isPushEnabled = await StoreServices.isEnabled();
//
//     if (!isPushEnabled) {
//       print("🚫 Push notifications disabled, ignoring background message");
//       return;
//     }
//
//     print("📩 Handling a background message: ${message.messageId}");
//   }
//
//   /// Show local notification (works on both Android & iOS)
//   static Future<void> showNotification({
//     required int id,
//     required String? title,
//     required String? body,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel_id',
//       'Default',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: 'ic_notification',
//     );
//
//     const iOSDetails = DarwinNotificationDetails();
//
//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//
//   /// Proper Firebase permission request (iOS only)
//   Future<void> _requestFirebasePermission() async {
//     if (Platform.isIOS) {
//       final settings = await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );
//
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print("✅ iOS Notification permission granted");
//       } else {
//         print("❌ iOS Notification permission denied");
//       }
//     } else if (Platform.isAndroid) {
//       if (await Permission.notification.isDenied) {
//         final status = await Permission.notification.request();
//         if (status.isGranted) {
//           print("✅ Notification permission granted (Android)");
//         } else {
//           print("❌ Notification permission denied (Android)");
//         }
//       }
//     }
//   }
// }
//
// /// Ask user for notification permission & guide to settings if denied
// Future<void> requestNotificationPermission(BuildContext context) async {
//   if (Platform.isAndroid) {
//     if (await Permission.notification.isDenied) {
//       final status = await Permission.notification.request();
//       if (status.isGranted) {
//         print("✅ Notification permission granted (Android)");
//       } else {
//         print("❌ Notification permission denied (Android)");
//         _showPermissionDialog(context);
//       }
//     }
//   } else if (Platform.isIOS) {
//     final settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("✅ Notification permission granted (iOS)");
//     } else {
//       print("❌ Notification permission denied (iOS)");
//       _showPermissionDialog(context);
//     }
//   }
// }
//
// void _showPermissionDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: LargeText(
//         text: context.l10n.notificationPermission,
//         fontSize: 22,
//       ),
//       content: LargeText(text: context.l10n.enableNotifications),
//       actions: [
//         TextButton(
//           onPressed: () {
//             openAppSettings();
//             Navigator.of(context).pop();
//           },
//           child: Text(
//             context.l10n.openSettings,
//             style: TextStyle(
//               fontSize: 16,
//               fontFamily: Fonts.urbanistRegular,
//               fontWeight: FontWeight.w400,
//               color: ColorConstants.greyDarkColor,
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // closes the dialog
//           },
//           child: MediumText(
//             text: context.l10n.cancel,
//             fontSize: 16,
//             fontFamily: Fonts.urbanistRegular,
//             fontWeight: FontWeight.w400,
//             color: ColorConstants.greyDarkColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
//
//
//
