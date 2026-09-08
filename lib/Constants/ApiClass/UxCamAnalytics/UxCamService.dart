import 'package:flutter_uxcam/flutter_uxcam.dart';

class UxCamService {
  UxCamService._();

  static final UxCamService instance = UxCamService._();

  Future<void> logScreen(String screenName) async {
    FlutterUxcam.tagScreenName(screenName);
  }

  Future<void> buttonPressed(
      String buttonName,
      String screenName,
      ) async {
    FlutterUxcam.logEvent(buttonName);
  }
}