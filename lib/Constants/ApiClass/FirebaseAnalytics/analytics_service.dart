import 'package:firebase_analytics/firebase_analytics.dart';
import 'event_names.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ---------------------------
  // Screen View
  // ---------------------------
  Future<void> logVisibleScreen(String screenName) async {
    await _analytics.logScreenView(
      screenClass: screenName,
      screenName: screenName,
    );
  }

  Future<void> buttonPressed(String buttonName, String screenName) async {
    await FirebaseAnalytics.instance.logEvent(
      name: buttonName,
      parameters: {'screenName': screenName},
    );
  }

  Future<void> logManufacturerListLoaded(int count) async {
    await _analytics.logEvent(
      name: FirebaseEvents.onBoardingScreen,
      parameters: {'count': count},
    );
  }
}
