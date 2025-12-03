import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceDetails() async {
    try {
      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        return {
          "device_type": "android",
          "model": android.model,
          "brand": android.brand,
          "os": "Android ${android.version.release}",
        };
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        return {
          "device_type": "ios",
          "model": ios.name,
          "brand": "Apple",
          "os": "${ios.systemName} ${ios.systemVersion}",
        };
      }
    } catch (e) {}

    // Fallback (web, desktop, etc.)
    return {
      "device_type": "unknown",
      "model": "",
      "brand": "",
      "os": "",
    };
  }
}
