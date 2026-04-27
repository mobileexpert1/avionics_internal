import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_analytics/firebase_analytics.dart';
import '../shared_prefs_helper.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  final String _userId = "";

  Future<void> init() async {
    await _analytics.setUserId(id: _userId);
  }

  Future<String> _generateUserId() async {
    final storedId = await SharedPrefsHelper.read();
    final uid = storedId ?? "";
    if (kIsWeb) {
      return "web_user_$uid";
    }
    try {
      if (Platform.isAndroid) {
        return "mobile_user_Android_$uid";
      } else if (Platform.isIOS) {
        return "mobile_user_IOS_$uid";
      }
    } catch (_) {}
    return "unknown_platform_$uid";
  }

  Future<void> logVisibleScreen(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
      parameters: {
        'currentUserId': await _generateUserId(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    // print(
    //   "Uploaded Visible Parameters: screenName $screenName,  ${{'currentUserId': await _generateUserId(), 'timestamp': DateTime.now().toIso8601String()}}",
    // );
  }

  Future<void> buttonPressed(String buttonName, String screenName) async {
    await _analytics.logEvent(
      name: buttonName,
      parameters: {
        'screenName': screenName,
        'currentUserId': await _generateUserId(),
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    // print(
    //   "Uploaded Button Parameters:screenName $screenName,  ${{'currentUserId': await _generateUserId(), 'timestamp': DateTime.now().toIso8601String()}}",
    // );
  }
}
