import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';

/// ======================================================
/// DEPENDENCY CONTRACT (OTP STYLE)
/// ======================================================
abstract class SubscriptionDeps {
  Future<dynamic> post({
    required Uri url,
    required Map<String, dynamic> body,
  });
}

/// ======================================================
/// MOCKS & FAKES
/// ======================================================
class MockSubscriptionDeps extends Mock
    implements SubscriptionDeps {}

class FakeUri extends Fake implements Uri {}

/// ======================================================
/// TESTABLE REPOSITORY (SINGLE CLASS)
/// ======================================================
class AppleSubscriptionRepository {
  final SubscriptionDeps deps;

  AppleSubscriptionRepository(this.deps);

  Future<BaseDetailResponseModel> postSubscriptionApi({
    required String token,
    required String selectedSubscritionId,
    required String platform,
    required String packageName,
  }) async {
    final response = await deps.post(
      url: Uri.parse('https://dummy-url'),
      body: {
        "platform": platform,
        "product_id": selectedSubscritionId,
        "package_name": packageName,
        "token": token,
      },
    );

    return BaseDetailResponseModel.fromJson(response);
  }
}

/// ======================================================
/// ✅ SINGLE TEST CLASS
/// ======================================================
class AppleSubscriptionRepositoryTest {
  late MockSubscriptionDeps mockDeps;
  late AppleSubscriptionRepository repository;

  /// ---------- SETUP
  void setup() {
    registerFallbackValue(FakeUri());
    mockDeps = MockSubscriptionDeps();
    repository = AppleSubscriptionRepository(mockDeps);
  }

  /// ---------- SUCCESS MOCK
  void mockSuccessApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenAnswer((_) async => {
      "detail": "Subscription verified successfully",
    });
  }

  /// ---------- FAILURE MOCK
  void mockFailureApi() {
    when(() => mockDeps.post(
      url: any(named: 'url'),
      body: any(named: 'body'),
    )).thenThrow(Exception("Invalid subscription"));
  }

  /// ---------- SUCCESS TEST
  Future<void> successTest() async {
    print("🟢 SUBSCRIPTION SUCCESS TEST");

    mockSuccessApi();

    final result = await repository.postSubscriptionApi(
      token: "valid_token",
      selectedSubscritionId: "sub_123",
      platform: "ios",
      packageName: "com.test.app",
    );

    expect(result.detail, "Subscription verified successfully");

    print("✅ SUBSCRIPTION SUCCESS PASSED");
  }

  /// ---------- FAILURE TEST
  Future<void> failureTest() async {
    print("🔴 SUBSCRIPTION FAILURE TEST");

    mockFailureApi();

    try {
      await repository.postSubscriptionApi(
        token: "invalid",
        selectedSubscritionId: "sub_000",
        platform: "ios",
        packageName: "com.test.app",
      );
      fail("Exception expected");
    } catch (e) {
      expect(e, isA<Exception>());
      print("⚠️ ERROR CAUGHT: $e");
    }

    print("✅ SUBSCRIPTION FAILURE PASSED");
  }

  /// ---------- RUN TESTS
  void run() {
    group('AppleSubscriptionRepository Tests', () {
      test('Subscription Success', () async => await successTest());
      test('Subscription Failure', () async => await failureTest());
    });
  }
}

/// ======================================================
/// MAIN
/// ======================================================
void main() {
  final testClass = AppleSubscriptionRepositoryTest();

  setUpAll(() {
    testClass.setup();
  });

  testClass.run();
}
