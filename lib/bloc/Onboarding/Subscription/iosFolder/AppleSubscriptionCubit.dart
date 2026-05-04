import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Screens/Onboarding/Login/LoginScreen.dart';
import 'AppleSubscriptionState.dart';
import 'AppleSubscriptionRepository.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';

// ---------------- Entitlement ----------------
const String _entitlement = 'Avioflai Pro';

// ---------------- RevenueCat Keys ----------------
const String _rcAppleApiKey = 'appl_fyiYkNFxAHXQCEUVuZbxJsicfHX';
const String _rcAndroidApiKey = 'goog_YOUR_REVENUECAT_KEY_HERE';

class AppleSubscriptionCubit extends Cubit<AppleSubscriptionState> {
  bool _isConfigured = false;

  AppleSubscriptionCubit() : super(AppleSubscriptionState()) {
    _initRevenueCat();
  }

  String _getRCUserId(String email) {
    return email.trim().toLowerCase();
  }

  Future<void> _initRevenueCat() async {
    if (kIsWeb) return;
    emit(state.copyWith(loading: true));
    try {
      final email = await SharedPrefsHelper.getEmail();
      print("Email Id For Login:- $email");
      await Purchases.setLogLevel(LogLevel.debug);
      final configuration =
          PurchasesConfiguration(
              Platform.isIOS ? _rcAppleApiKey : _rcAndroidApiKey,
            )
            ..appUserID = email
            ..diagnosticsEnabled = true;
      await Purchases.configure(configuration);
      _isConfigured = true;
      Purchases.addCustomerInfoUpdateListener(_handleCustomerInfo);
      if (email != null && email.isNotEmpty) {
        await _ensureLoggedIn(email);
      }
      await loadOfferings();
      await getSubscriptionsFromBackendServer();
    } catch (e) {
      if (!isClosed) {
        debugPrint("RC login: ${e.toString()}");
        emit(
          state.copyWith(loading: false, error: "RevenueCat init failed: $e"),
        );
      }
    }
  }

  Future<void> clearAllDataAndRedirectToSplashScreen(
    BuildContext context,
  ) async {
    try {
      await Purchases.logOut();
      await SharedPrefsHelper.clearAll([], false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= WAIT FOR CONFIG =================
  Future<void> _waitForConfig() async {
    int retry = 0;
    while (!_isConfigured && retry < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }

    if (!_isConfigured) {
      throw Exception("RevenueCat not initialized");
    }
  }

  // ================= LOGIN =================
  Future<void> loginUser(String email) async {
    try {
      if (!_isConfigured) {
        await _waitForConfig();
      }

      final rcUserId = _getRCUserId(email);
      final result = await Purchases.logIn(rcUserId);
      debugPrint("RC Success login: $result");
    } catch (e) {
      debugPrint("RC False login failed: $e");
    }
  }

  // ================= ENSURE LOGIN =================
  Future<void> _ensureLoggedIn(String email) async {
    try {
      final rcUserId = _getRCUserId(email);
      final info = await Purchases.getCustomerInfo();

      if (info.originalAppUserId != rcUserId) {
        final result = await Purchases.logIn(rcUserId);
        debugPrint("Ensure LoggedIn: $result");
      }
    } catch (e) {
      debugPrint("Ensure RC login failed: $e");
    }
  }

  // ================= CUSTOMER INFO =================
  Future<void> _handleCustomerInfo(CustomerInfo info) async {
    if (isClosed) return;

    final entitlement = info.entitlements.active[_entitlement];
    final isActive = entitlement != null;
    if (!isClosed) {
      emit(
        state.copyWith(
          purchased: isActive,
          loading: false,
          activeProductId: entitlement?.productIdentifier,
          status: CommonApiStatus.success,
        ),
      );
    }
  }

  // ================= LOAD OFFERINGS =================
  Future<void> loadOfferings() async {
    emit(state.copyWith(loading: true));
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        emit(state.copyWith(loading: false, error: "No offerings found"));
        return;
      }
      if (!isClosed) {
        emit(state.copyWith(loading: false, offerings: offerings));
      }
    } catch (e) {
      if (!isClosed) {
        debugPrint("${e.toString()}");
        emit(
          state.copyWith(loading: false, error: "Failed to load offerings: $e"),
        );
      }
    }
  }

  // ================= SELECT PACKAGE =================
  void selectPackage(Package package) {
    emit(state.copyWith(selectedPackage: package));
  }

  // ================= PURCHASE =================
  Future<void> buySelected() async {
    final package = state.selectedPackage;

    if (package == null) {
      emit(state.copyWith(error: "No subscription selected"));
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      final result = await Purchases.purchasePackage(package);
      final customerInfo = result.customerInfo;
      _handleCustomerInfo(customerInfo);
      await getSubscriptionsFromBackendServer();
      debugPrint("Purchase done");
      debugPrint("Active entitlements: ${customerInfo.entitlements.active}");
      debugPrint("RC User ID: ${customerInfo.originalAppUserId}");
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(loading: false, error: e.message ?? "Purchase failed"),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(loading: false, error: "Unexpected error: $e"));
    }
  }

  // ================= RESTORE =================
  Future<void> restorePurchases() async {
    emit(state.copyWith(loading: true));

    try {
      final customerInfo = await Purchases.restorePurchases();
      _handleCustomerInfo(customerInfo);
      await getSubscriptionsFromBackendServer();
      if (!customerInfo.entitlements.active.containsKey(_entitlement)) {
        emit(
          state.copyWith(loading: false, error: "No active subscription found"),
        );
      }
    } catch (e) {
      debugPrint(e.toString());

      if (e is PlatformException &&
          e.details != null &&
          e.details['readable_error_code'] == "RECEIPT_ALREADY_IN_USE") {
        emit(
          state.copyWith(
            loading: false,
            error:
                "This Apple ID is already linked with another account. Please login with the original account.",
          ),
        );
      } else {
        emit(
          state.copyWith(
            loading: false,
            error: "Restore failed. Please try again.",
          ),
        );
      }
    }
  }

  bool _isSyncing = false;

  // ================= BACKEND FETCH =================
  Future<void> getSubscriptionsFromBackendServer() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final response = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      final isActive = response.data?.status == "active";

      final rcActive = state.purchased;

      emit(
        state.copyWith(
          subscription: response.data,
          purchased: rcActive || isActive,
          activeProductId: rcActive
              ? state.activeProductId
              : (isActive ? response.data?.productId : null),
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    } finally {
      _isSyncing = false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint("RC logout failed: $e");
    }
  }

  // ================= CANCEL GUIDE =================
  Future<void> guideUserToCancelSubscription() async {
    if (!state.purchased) {
      emit(state.copyWith(error: "No active subscription"));
      return;
    }

    try {
      final url = Platform.isIOS
          ? 'https://apps.apple.com/account/subscriptions'
          : 'https://play.google.com/store/account/subscriptions';

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(error: "Failed to open subscription page: $e"));
    }
  }

  // ================= DISPOSE =================
  @override
  Future<void> close() {
    Purchases.removeCustomerInfoUpdateListener(_handleCustomerInfo);
    return super.close();
  }
}
