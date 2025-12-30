// test/firebase_mock_test.dart  (official working mock from FlutterFire – copy this exactly)

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const MethodChannel _kChannel = MethodChannel('plugins.flutter.io/firebase_core');

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the legacy channel to return a default app on initializeCore
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_kChannel, (MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'fake',
            'appId': 'fake',
            'messagingSenderId': 'fake',
            'projectId': 'fake',
          },
          'pluginConstants': <String, dynamic>{},
        }
      ];
    }
    return null;
  });

  // Mock the Pigeon channel to avoid channel-error
  const MethodChannel pigeonChannel = MethodChannel(
      'dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.initializeCore');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pigeonChannel, (MethodCall methodCall) async {
    return {'apps': []};
  });
}