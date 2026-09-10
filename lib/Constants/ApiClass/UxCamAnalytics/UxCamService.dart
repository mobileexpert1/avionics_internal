import 'package:flutter/foundation.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class UxCamService {
  UxCamService._();

  static final UxCamService instance = UxCamService._();

  Future<void> logScreen(String screenName) async {
    if (kIsWeb) {
      return;
    }

    await FlutterUxcam.tagScreenName(screenName);
  }

  Future<void> buttonPressed(String buttonName, String screenName) async {
    await FlutterUxcam.logEvent(buttonName);
  }
}
