// test/repository/signup_repository_test.dart  (fixed and improved version)

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avionics_internal/bloc/Onboarding/signup/signup_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SignupRepository repository;

  const MethodChannel connectivityChannel =
  MethodChannel('dev.fluttercommunity.plus/connectivity');

  setUpAll(() async {
    // Mock connectivity to always return connected
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, (call) async {
      if (call.method == 'check') return 'wifi';
      return null;
    });

    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    HttpOverrides.global = null;
    repository = SignupRepository();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  group('Check Email', () {
    test('checkIsEmailAlreadyResgisteredOrNot returns true when email exists', () async {
      HttpOverrides.global = _SuccessHttpOverride(isCheckEmail: true);

      final response = await repository.checkIsEmailAlreadyResgisteredOrNot(
        email: 'test@example.com',
      );

      expect(response, true); // assuming it returns bool true when registered
    });

    test('checkIsEmailAlreadyResgisteredOrNot throws error on failure', () async {
      HttpOverrides.global = _FailureHttpOverride();

      expect(
            () => repository.checkIsEmailAlreadyResgisteredOrNot(email: 'fail@test.com'),
        throwsA(isA<String>()),
      );
    });
  });

  group('Register User', () {
    test('registerUser returns true on success', () async {
      HttpOverrides.global = _SuccessHttpOverride(isRegister: true);

      final response = await repository.registerUser(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        password: '123456',
        phone_number: '1234567890',
        professional_role: 'Developer',
        experience_level: '2',
        user_type: 'user',
        auth_type: 'email',
      );

      expect(response, true); // assuming it returns bool true on success
    });

    test('registerUser throws error on failure', () async {
      HttpOverrides.global = _FailureHttpOverride();

      expect(
            () => repository.registerUser(
          first_name: 'Fail',
          last_name: 'User',
          email: 'fail@example.com',
          password: 'wrong',
          phone_number: '000',
          professional_role: 'Dev',
          experience_level: '0',
          user_type: 'user',
          auth_type: 'email',
        ),
        throwsA(isA<String>()),
      );
    });
  });
}

// ──────────────────────────────────────────────────────────────
// HTTP Mock Classes (fixed to return proper bool responses)
// ──────────────────────────────────────────────────────────────

class _SuccessHttpOverride extends HttpOverrides {
  final bool isCheckEmail;
  final bool isRegister;

  _SuccessHttpOverride({this.isCheckEmail = false, this.isRegister = false});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient(success: true, isCheckEmail: isCheckEmail, isRegister: isRegister);
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
  final bool isCheckEmail;
  final bool isRegister;

  _MockHttpClient({required this.success, this.isCheckEmail = false, this.isRegister = false});

  @override
  Future<HttpClientRequest> postUrl(Uri url) async {
    final path = url.path.toLowerCase();
    final checkEmail = path.contains('checkemail') || path.contains('email');
    final register = path.contains('register') || path.contains('signup');

    return _MockHttpRequest(
      success: success,
      isCheckEmail: checkEmail,
      isRegister: register,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpRequest implements HttpClientRequest {
  final bool success;
  final bool isCheckEmail;
  final bool isRegister;

  _MockHttpRequest({required this.success, required this.isCheckEmail, required this.isRegister});

  @override
  Future<HttpClientResponse> close() async {
    if (!success) throw Exception('API Failed');
    return _MockHttpResponse(isCheckEmail: isCheckEmail, isRegister: isRegister);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpResponse implements HttpClientResponse {
  final bool isCheckEmail;
  final bool isRegister;

  _MockHttpResponse({required this.isCheckEmail, required this.isRegister});

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(
      void Function(List<int> event)? onData, {
        Function? onError,
        void Function()? onDone,
        bool? cancelOnError,
      }) {
    // Adjust this JSON to match exactly what your real API returns
    // and how your SignupRepository parses it to return bool
    late Map<String, dynamic> jsonResponse;

    if (isRegister) {
      jsonResponse = {
        "status": true,
        "message": "User registered successfully",
        // add other fields if needed
      };
    } else if (isCheckEmail) {
      jsonResponse = {
        "status": true,
        "data": [{"email": "test@example.com"}], // means already registered
        "message": "Email exists"
      };
    } else {
      jsonResponse = {"status": true};
    }

    final bytes = utf8.encode(jsonEncode(jsonResponse));
    final stream = Stream<List<int>>.fromIterable([bytes]);

    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}