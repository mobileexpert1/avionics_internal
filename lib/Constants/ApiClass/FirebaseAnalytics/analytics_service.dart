import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ---------------------------
  // Initialize (safe for Web)
  // ---------------------------
  Future<void> init() async {
    await _analytics.setUserId(id: _generateUserId());
  }

  String _generateUserId() {
    if (kIsWeb) {
      return "web_user_${DateTime.now().millisecondsSinceEpoch}";
    }
    return "mobile_user_${DateTime.now().millisecondsSinceEpoch}";
  }

  // ---------------------------
  // Screen View
  // ---------------------------
  Future<void> logVisibleScreen(String screenName) async {
    await _analytics.logScreenView(
      screenClass: screenName,
      screenName: screenName,
    );
  }

  // ---------------------------
  // Button Press
  // ---------------------------
  Future<void> buttonPressed(String buttonName, String screenName) async {
    await _analytics.logEvent(
      name: buttonName,
      parameters: {'screenName': screenName},
    );
  }

  // ---------------------------
  // Generic Event
  // ---------------------------
  Future<void> logEvent(
    String eventName, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}
