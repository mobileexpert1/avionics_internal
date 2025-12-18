import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceDetails() async {
    try {
      if (kIsWeb) {
        final web = await deviceInfo.webBrowserInfo;
        return {
          "device_type": "web",
          "model": web.browserName.name,
          "brand": "Browser",
          "os": web.platform ?? "",
        };
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await deviceInfo.androidInfo;
        return {
          "device_type": "android",
          "model": android.model,
          "brand": android.brand,
          "os": "Android ${android.version.release}",
        };
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await deviceInfo.iosInfo;
        return {
          "device_type": "ios",
          "model": ios.name,
          "brand": "Apple",
          "os": "${ios.systemName} ${ios.systemVersion}",
        };
      }

      if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux) {
        return {
          "device_type": "desktop",
          "model": defaultTargetPlatform.name,
          "brand": "",
          "os": defaultTargetPlatform.name,
        };
      }
    } catch (e) {
      debugPrint("DeviceInfo error: $e");
    }

    return {
      "device_type": "unknown",
      "model": "",
      "brand": "",
      "os": "",
    };
  }
}
