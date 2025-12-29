// test/repository/login_repository_test.dart  (final version – no Firebase at all in test)

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avionics_internal/bloc/Onboarding/login/login_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LoginRepository repository;

  const MethodChannel connectivityChannel =
  MethodChannel('dev.fluttercommunity.plus/connectivity');

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, (call) async {
      if (call.method == 'check') return 'wifi';
      return null;
    });

    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    HttpOverrides.global = null;
    repository = LoginRepository();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  group('Email login', () {
    test('loginUser returns success response', () async {
      print('TEST: Email login - success - STARTED');
      HttpOverrides.global = _SuccessHttpOverride(socialLogin: false);

      final response = await repository.loginUser(
        email: 'test@test.com',
        password: '123456',
      );

      expect(response.userDetails, isNotNull);
      expect(response.userDetails!.email, 'test@test.com');
      expect(response.userDetails!.id, 'user_123');

      print('TEST: Email login - success - PASSED ✅');
    });

    test('loginUser throws error when API fails', () async {
      print('TEST: Email login - failure - STARTED');
      HttpOverrides.global = _FailureHttpOverride();

      expect(
            () => repository.loginUser(
          email: 'fail@test.com',
          password: 'wrong',
        ),
        throwsA(isA<String>()),
      );

      print('TEST: Email login - failure - PASSED ✅');
    });
  });

  group('Social login', () {
    test('loginUserWithSocialPlatform returns success', () async {
      print('TEST: Social login - success - STARTED');
      HttpOverrides.global = _SuccessHttpOverride(socialLogin: true);

      final response = await repository.loginUserWithSocialPlatform(
        provider: 'google',
        token: 'fake_token',
      );

      expect(response.userDetails, isNotNull);
      expect(response.userDetails!.id, 'social_123');
      expect(response.userDetails!.email, 'social@test.com');

      print('TEST: Social login - success - PASSED ✅');
    });

    test('loginUserWithSocialPlatform throws error when API fails', () async {
      print('TEST: Social login - failure - STARTED');
      HttpOverrides.global = _FailureHttpOverride();

      expect(
            () => repository.loginUserWithSocialPlatform(
          provider: 'google',
          token: 'invalid',
        ),
        throwsA(isA<String>()),
      );

      print('TEST: Social login - failure - PASSED ✅');
    });
  });
}

// HTTP mock classes – added more possible list fields to fix the type cast error
class _SuccessHttpOverride extends HttpOverrides {
  final bool socialLogin;
  _SuccessHttpOverride({this.socialLogin = false});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient(success: true, socialLogin: socialLogin);
  }
}

class _FailureHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient(success: false);
  }
}

class _MockHttpClient implements HttpClient {
  final bool success;
  final bool socialLogin;

  _MockHttpClient({required this.success, this.socialLogin = false});

  @override
  Future<HttpClientRequest> postUrl(Uri url) async {
    return _MockHttpRequest(success: success, socialLogin: socialLogin);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpRequest implements HttpClientRequest {
  final bool success;
  final bool socialLogin;

  _MockHttpRequest({required this.success, this.socialLogin = false});

  @override
  Future<HttpClientResponse> close() async {
    if (!success) throw Exception('API Failed');
    return _MockHttpResponse(socialLogin: socialLogin);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpResponse implements HttpClientResponse {
  final bool socialLogin;

  _MockHttpResponse({this.socialLogin = false});

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(
      void Function(List<int> event)? onData, {
        Function? onError,
        void Function()? onDone,
        bool? cancelOnError,
      }) {
    final Map<String, dynamic> jsonResponse = socialLogin
        ? {
      "status": true,
      "userDetails": {
        "id": "social_123",
        "email": "social@test.com",
        "name": "Social User",
      },
      "roles": ["user", "social"],
      "permissions": [],
      "tokens": [],
      "scopes": [],
      "refreshToken": "fake_refresh",
      "features": [],
      "departments": [],
      "groups": [],
      "privileges": [],
    }
        : {
      "status": true,
      "userDetails": {
        "id": "user_123",
        "email": "test@test.com",
        "name": "Test User",
      },
      "roles": ["user"],
      "permissions": [],
      "tokens": [],
      "scopes": [],
      "refreshToken": "fake_refresh",
      "features": [],
      "departments": [],
      "groups": [],
      "privileges": [],
    };

    final bytes = utf8.encode(jsonEncode(jsonResponse));
    final stream = Stream<List<int>>.fromIterable([bytes]);

    return stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}