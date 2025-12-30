import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

/// ======================================================
/// DEPENDENCY CONTRACT (WRAPPER)
/// ======================================================
abstract class ForgotDeps {
  Future<Map<String, dynamic>> post({
    required Uri url,
    required Map<String, dynamic> body,
  });
}

/// ======================================================
/// MOCKS & FAKES
/// ======================================================
class MockForgotDeps extends Mock implements ForgotDeps {}

class FakeUri extends Fake implements Uri {}

/// ======================================================
/// TESTABLE REPOSITORY (OTP STYLE)
/// ======================================================
class ForgotRepository {
  final ForgotDeps deps;

  ForgotRepository(this.deps);

  Future<BaseDetailResponseModel> forgotUserApi({
    required String email,
  }) async {
    try {
      final response = await deps.post(
        url: Uri.parse('https://dummy-url'),
        body: {"email": email},
      );

      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}

/// ======================================================
/// ✅ SINGLE TEST CLASS (ALL LOGIC INSIDE)
/// ======================================================
class ForgotRepositoryTest {
  late MockForgotDeps mockDeps;
  late ForgotRepository repository;

  /// ---------- SETUP
  void setup() {
    registerFallbackValue(FakeUri());
    mockDeps = MockForgotDeps();
    repository = ForgotRepository(mockDeps);
  }

  /// ---------- SUCCESS MOCK
  void mockSuccessApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenAnswer((_) async => {
      "success": true,
      "detail": "Email sent successfully",
    });
  }

  /// ---------- FAILURE MOCK
  void mockFailureApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenThrow(Exception("Email not found"));
  }

  /// ---------- SUCCESS TEST
  Future<void> successTest() async {
    print("🟢 FORGOT SUCCESS TEST");

    mockSuccessApi();

    final result = await repository.forgotUserApi(
      email: "test@gmail.com",
    );

    // expect(result.success, true);
    expect(result.detail, "Email sent successfully");

    print("✅ FORGOT SUCCESS PASSED");
  }

  /// ---------- FAILURE TEST
  Future<void> failureTest() async {
    print("🔴 FORGOT FAILURE TEST");

    mockFailureApi();

    try {
      await repository.forgotUserApi(email: "invalid@gmail.com");
      fail("Exception expected");
    } catch (e) {
      expect(e, isA<String>());
      print("⚠️ FORGOT ERROR CAUGHT: $e");
    }

    print("✅ FORGOT FAILURE PASSED");
  }

  /// ---------- RUN TESTS
  void run() {
    group('ForgotRepository Tests', () {
      test('Forgot Success', () async => await successTest());
      test('Forgot Failure', () async => await failureTest());
    });
  }
}

/// ======================================================
/// MAIN
/// ======================================================
void main() {
  final forgotTest = ForgotRepositoryTest();

  setUpAll(() {
    forgotTest.setup();
  });

  forgotTest.run();
}
