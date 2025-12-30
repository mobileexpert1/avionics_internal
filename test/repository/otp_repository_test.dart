import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:avionics_internal/bloc/Onboarding/login/login_response_model.dart';

/// ======================================================
/// DEPENDENCY CONTRACT
/// ======================================================
abstract class OtpDeps {
  Future<dynamic> post({
    required Uri url,
    required Map<String, dynamic> body,
  });

  Future<void> saveUser(String id);
}

/// ======================================================
/// MOCKS & FAKES
/// ======================================================
class MockOtpDeps extends Mock implements OtpDeps {}

class FakeUri extends Fake implements Uri {}

/// ======================================================
/// REPOSITORY (TESTABLE VERSION)
/// ======================================================
class OtpRepository {
  final OtpDeps deps;

  OtpRepository(this.deps);

  Future<LoginResponseModel> otpVerifyApi({
    required String email,
    required String otp,
    required String otpType,
  }) async {
    try {
      final response = await deps.post(
        url: Uri.parse('https://dummy-url'),
        body: {
          "email": email,
          "otp": otp,
          "otp_type": otpType,
        },
      );

      final model = LoginResponseModel.fromJson(response);

      if (model.userDetails?.id != null) {
        await deps.saveUser(model.userDetails!.id);
      }

      return model;
    } catch (e) {
      throw e;
    }
  }
}

/// ======================================================
/// ✅ OTP TEST CLASS
/// ======================================================
class OtpRepositoryTest {
  late MockOtpDeps mockDeps;
  late OtpRepository repository;

  /// ---------- SETUP
  void setup() {
    registerFallbackValue(FakeUri());
    mockDeps = MockOtpDeps();
    repository = OtpRepository(mockDeps);
  }

  /// ---------- SUCCESS MOCK
  void mockSuccessApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenAnswer((_) async => {
      "detail": "Success",
      "is_verified": true,
      "is_avatar": true,
      "access": "dummy_access_token",
      "refresh": "dummy_refresh_token",
      "token_type": "Bearer",
      "user_details": {
        "id": "101",
        "first_name": "Test",
        "last_name": "User",
        "email": "test@gmail.com",
        "phone_number": "9999999999",
        "professional_role": "Developer",
        "experience_level": "Intermediate",
        "user_type": "user",
        "auth_type": "email",
        "is_active": true,
        "is_active_subscription": true
      }
    });

    when(() => mockDeps.saveUser(any()))
        .thenAnswer((_) async {});
  }

  /// ---------- FAILURE MOCK
  void mockFailureApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenThrow(Exception("OTP invalid"));
  }

  /// ---------- SUCCESS TEST
  Future<void> successTest() async {
    print("🟢 OTP SUCCESS TEST");

    mockSuccessApi();

    final result = await repository.otpVerifyApi(
      email: "test@gmail.com",
      otp: "123456",
      otpType: "signup",
    );

    // Validate fields
    expect(result.userDetails?.id, "101");
    expect(result.userDetails?.firstName, "Test");
    expect(result.userDetails?.email, "test@gmail.com");

    verify(() => mockDeps.saveUser("101")).called(1);

    print("✅ SUCCESS PASSED");
  }

  /// ---------- FAILURE TEST
  Future<void> failureTest() async {
    print("🔴 OTP FAILURE TEST");

    mockFailureApi();

    try {
      await repository.otpVerifyApi(
        email: "test@gmail.com",
        otp: "000000",
        otpType: "signup",
      );
      fail("Exception expected");
    } catch (e) {
      expect(e, isA<Exception>());
      print("⚠️ ERROR CAUGHT: $e");
    }

    print("✅ FAILURE PASSED");
  }

  /// ---------- RUN TESTS
  void run() {
    group('OtpRepository Tests', () {
      test('OTP Success', () async => await successTest());
      test('OTP Failure', () async => await failureTest());
    });
  }
}

/// ======================================================
/// MAIN
/// ======================================================
void main() {
  final otpTest = OtpRepositoryTest();

  setUpAll(() {
    otpTest.setup();
  });

  otpTest.run();
}
