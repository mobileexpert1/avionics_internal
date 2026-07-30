import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Helpers/CreditManager/CreditManager.dart';
import '../../../../Helpers/NoInternetDialog.dart';
import '../../../../Screens/Onboarding/Login/LoginScreen.dart';
import '../../../home/homeBloc/home_cubit.dart';
import 'SubscriptionBuyPlanRepository.dart';
import 'SubscriptionBuyPlanState.dart';

const String _rcAppleApiKey = 'appl_fyiYkNFxAHXQCEUVuZbxJsicfHX';
const String _rcAndroidApiKey = 'goog_nQAujUhKgFBEPESGnzMOczSTIOv';

class SubscriptionBuyPlanCubit extends Cubit<SubscriptionBuyPlanState> {
  bool _isConfigured = false;
  bool isComeFromSignup = false;
  bool isProductChangeRequest = false;
  bool globalWebRedirectDone = false;

  static const avioflaiPRO = 'Avioflai Pro';
  static const avioflaiBASIC = 'Avioflai';

  SubscriptionBuyPlanCubit() : super(SubscriptionBuyPlanState());

  String getPackageDescriptionTitle(String description) {
    if (description.contains('Small')) {
      return ('Light (L)');
    }
    if (description.contains('Medium')) {
      return ('Medium (M)');
    }
    if (description.contains('Large')) {
      return ('Heavy (H)');
    }
    return description;
  }

  String _getRCUserId(String email) {
    return email.trim().toLowerCase();
  }

  Future<void> handleWebRedirectionIfNeeded(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      if (globalWebRedirectDone) return;
      globalWebRedirectDone = true;

      final webSessionToken = await SubscriptionBuyPlanRepository()
          .getSubscriptionSessionToken();

      if (webSessionToken.session == "" || webSessionToken.session == null) {
        return;
      }
      final callback = Uri.encodeComponent(Uri.base.toString());

      final url =
          "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlConstant.userService}subscription/choose/${webSessionToken.session}?callback=$callback";

      print(url);

      final uri = Uri.parse(url);
      if (kIsWeb) {
        await launchUrl(uri, webOnlyWindowName: '_self');
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await handleWebRedirectionIfNeeded(context);
        },
      );
    }
  }

  Future<void> handleWebRedirectionIfNeededForAddOnPacks(
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      if (globalWebRedirectDone) return;
      globalWebRedirectDone = true;

      final webSessionToken = await SubscriptionBuyPlanRepository()
          .getSubscriptionSessionToken();

      if (webSessionToken.session == "" || webSessionToken.session == null) {
        return;
      }
      final callback = Uri.encodeComponent(Uri.base.toString());

      final url =
          "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlConstant.userService}subscription/consumables/${webSessionToken.session}?callback=$callback&title=Consumables";
      print(url);

      final uri = Uri.parse(url);
      if (kIsWeb) {
        await launchUrl(uri, webOnlyWindowName: '_self');
      } else {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await handleWebRedirectionIfNeeded(context);
        },
      );
    }
  }

  Future<void> initRevenueCat(
    bool isComeFromProfile,
    BuildContext context,
  ) async {
    if (kIsWeb) return;
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(loading: true, isComeFromProfile: isComeFromProfile));
      try {
        final email = await SharedPrefsHelper.getEmail();

        if (email == null || email.isEmpty) {
          debugPrint("Email Null");
          emit(state.copyWith(loading: false, error: "User not logged in"));
          return;
        }

        final rcUserId = _getRCUserId(email);

        await Purchases.setLogLevel(LogLevel.debug);
        final configuration =
            PurchasesConfiguration(
                Platform.isIOS ? _rcAppleApiKey : _rcAndroidApiKey,
              )
              ..appUserID = rcUserId
              ..diagnosticsEnabled = true;
        if (await Purchases.isConfigured == false) {
          await Purchases.configure(configuration);
        }

        await loginUser(rcUserId);

        if (!_isConfigured) {
          Purchases.addCustomerInfoUpdateListener(_handleCustomerInfo);
          _isConfigured = true;
        }

        final info = await Purchases.getCustomerInfo();
        if (info.entitlements.active.isNotEmpty) {
          _handleCustomerInfo(info);
        }

        try {
          await Purchases.restorePurchases();
        } catch (e) {
          if (e is PlatformException &&
              e.details != null &&
              e.details['readable_error_code'] == "RECEIPT_ALREADY_IN_USE") {
            emit(
              state.copyWith(
                isBlocked: isComeFromProfile == true ? false : true,
                loading: false,
                error: isComeFromProfile == true
                    ? "This account is already linked to another ${Platform.isIOS ? "Apple" : "Google"} account. Please log in with the original account to access this feature."
                    : "This account is already linked with another ${Platform.isIOS ? "Apple" : "Google"}. Please log in with the original account to access this feature.",
              ),
            );
            return;
          }
        }

        await loadOfferings();
      } catch (e) {
        if (!isClosed) {
          debugPrint("RC login: ${e.toString()}");
          if (e is PlatformException) {
            emit(state.copyWith(loading: false, error: "${e.message}"));
          } else {
            emit(state.copyWith(loading: false, error: "$e"));
          }
        }
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await initRevenueCat(isComeFromProfile, context);
        },
      );
    }
  }

  Future<void> clearAllDataAndRedirectToSplashScreen(
    BuildContext context,
  ) async {
    try {
      await Purchases.logOut();
      await Purchases.invalidateCustomerInfoCache();
      await SharedPrefsHelper.clearAll([], false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
      await SharedPrefsHelper.clearAll([], false);
      if (isClosed) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> loginUser(String email) async {
    try {
      final rcUserId = _getRCUserId(email);
      final result = await Purchases.logIn(rcUserId);
      debugPrint("RC Success login: $result");
    } catch (e) {
      debugPrint("RC False login failed: $e");
      if (e is PlatformException) {
        debugPrint('message: ${e.message}');
      }
    }
  }

  // ================= CUSTOMER INFO =================
  Future<void> _handleCustomerInfo(CustomerInfo info) async {
    if (isClosed) return;

    final entitlements = info.entitlements.active;

    final isPro = entitlements.containsKey(avioflaiPRO);
    final isBasic = entitlements.containsKey(avioflaiBASIC);

    final isActive = isPro || isBasic;

    final activeProductId = isPro
        ? entitlements[avioflaiPRO]?.productIdentifier
        : entitlements[avioflaiBASIC]?.productIdentifier;

    if (isActive) {
      emit(state.copyWith(waitingForBackendConfirmation: true, loading: true));
      if (!isClosed) {
        await waitForBackendConfirmation(isPro, activeProductId ?? "");
      }
    } else {
      emit(state.copyWith(purchased: false, loading: false));
    }
  }

  Future<void> waitForBackendConfirmation(
    bool isPro,
    String activeProductId,
  ) async {
    if (isClosed) return;

    const maxRetry = 5;

    for (int i = 0; i < maxRetry; i++) {
      try {
        final response = await SubscriptionBuyPlanRepository()
            .getSubscriptionDetails();

        final isBackendActive = response.data?.status == "active";

        if (isBackendActive) {
          emit(
            state.copyWith(
              subscription: response,
              purchased: true,
              isProUser: isPro,
              activeProductId: activeProductId,
              waitingForBackendConfirmation: false,
              loading: false,
              status: CommonApiStatus.success,
            ),
          );
          return;
        }
      } catch (e) {
        //emit(state.copyWith(error: e.toString()));
      }
      if (!isClosed) {
        await Future.delayed(const Duration(seconds: 6));
      }
    }
    if (!isClosed) {
      emit(
        state.copyWith(
          purchased: false,
          waitingForBackendConfirmation: false,
          loading: false,
          // error: "In Progress to verification",
        ),
      );
    }
  }

  Future<void> isRefreshTheScreen(bool isRefresh) async {
    emit(state.copyWith(loading: isRefresh));
  }

  // ================= LOAD OFFERINGS =================
  Future<void> loadOfferings() async {
    emit(state.copyWith(loading: true));

    try {
      final offerings = await Purchases.getOfferings();

      if (offerings.current == null) {
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            loading: false,
            error: 'No offerings',
            isBlocked: false,
          ),
        );
        return;
      }

      final current = offerings.current!;

      List<Package> subscriptionPackages = [];
      List<Package> consumablePackages = [];

      for (final package in current.availablePackages) {
        final productId = package.storeProduct.identifier.toLowerCase();
        // CONSUMABLES
        if (productId.contains("token") || productId.contains("credit")) {
          consumablePackages.add(package);
        } else {
          subscriptionPackages.add(package);
        }
      }

      emit(
        state.copyWith(
          loading: false,
          status: CommonApiStatus.success,
          offerings: offerings,

          subscriptionPackages: subscriptionPackages,

          consumablePackages: consumablePackages,

          isBlocked: false,
        ),
      );
    } catch (e) {
      await Future.delayed(Duration(seconds: 2));
      try {
        final offerings = await Purchases.getOfferings();
        if (offerings.current == null) {
          emit(
            state.copyWith(
              status: CommonApiStatus.failure,
              loading: false,
              error: 'No offerings',
              isBlocked: false,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            loading: false,
            offerings: offerings,
            isBlocked: false,
          ),
        );
      } catch (e) {
        if (e is PlatformException &&
            e.details != null &&
            e.details['readable_error_code'] == "CONFIGURATION_ERROR") {
          emit(
            state.copyWith(
              loading: false,
              error:
                  "There is an issue with your configuration. Check the underlying error for more details",
            ),
          );
          return;
        } else {
          debugPrint(e.toString());
          emit(
            state.copyWith(
              loading: false,
              error: "Failed to load offerings ${e.toString()}",
            ),
          );
        }
      }
    }
  }

  // ================= SELECT PACKAGE =================
  void selectPackage(Package package) {
    emit(state.copyWith(selectedPackage: package));
  }

  void selectConsumablePackage(Package package) {
    emit(state.copyWith(selectedConsumablePackage: package));
  }

  // ================= PURCHASE =================

  void resetConsumablePurchaseState() {
    emit(state.copyWith(consumablePurchased: false));
  }

  Future<void> buyConsumable(BuildContext context) async {
    final package = state.selectedConsumablePackage;

    if (package == null) {
      emit(state.copyWith(error: "No consumable selected"));

      return;
    }

    emit(state.copyWith(loading: true, consumablePurchased: false));

    try {
      await Purchases.purchase(PurchaseParams.package(package));

      debugPrint(
        "Consumable purchased: "
        "${package.storeProduct.identifier}",
      );

      Future.delayed(const Duration(seconds: 2), () async {
        print(
          "Before tokenAlreadyAdded-=-=-${CreditManager().tokenAlreadyAdded}",
        );
        print(
          "Before CreditAlreadyAdded-=-=-${CreditManager().creditAlreadyAdded}",
        );

        final response = await HomeCubit().fetchHomeData(context);

        print(
          "After tokenAlreadyAdded-=-=-${CreditManager().tokenAlreadyAdded}",
        );
        print(
          "After CreditAlreadyAdded-=-=-${CreditManager().creditAlreadyAdded}",
        );

        if (CreditManager().tokenAlreadyAdded <=
                response!.currentPlan!.alreadyTotalAddOnToken ||
            CreditManager().creditAlreadyAdded <=
                response.currentPlan!.alreadyTotalAddOnCredit) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, consumablePurchased: true));
          }
        }
      });
    } on PlatformException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, consumablePurchased: false));
      }
      _handlePurchaseError(e);
    }
  }

  Future<void> buySelected() async {
    final package = state.selectedPackage;

    if (package == null) {
      emit(state.copyWith(error: "No subscription selected"));
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      final customerInfo = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      await _handleCustomerInfo(customerInfo.customerInfo);
      final entitlements = customerInfo.customerInfo.entitlements.active;
      final isPro = entitlements.containsKey(avioflaiPRO);
      final activeProductId = isPro
          ? entitlements[avioflaiPRO]?.productIdentifier
          : entitlements[avioflaiBASIC]?.productIdentifier;

      if (activeProductId == null) {
        emit(
          state.copyWith(
            loading: false,
            error: "Unable to verify subscription",
          ),
        );
        return;
      }
    } on PlatformException catch (e) {
      if (e.toString().toLowerCase().contains(
        "purchased product was missing".toLowerCase(),
      )) {
        emit(state.copyWith(loading: false));
        buySelected();
      } else {
        _handlePurchaseError(e);
      }
    }
  }

  // ================= RESTORE =================
  Future<void> restorePurchases() async {
    emit(state.copyWith(loading: true));

    try {
      final customerInfo = await Purchases.restorePurchases();
      await _handleCustomerInfo(customerInfo);

      final entitlements = customerInfo.entitlements.active;

      final hasSubscription =
          entitlements.containsKey(avioflaiPRO) ||
          entitlements.containsKey(avioflaiBASIC);

      if (!hasSubscription) {
        emit(
          state.copyWith(
            loading: false,
            error: "No active subscription found",
            isBlocked: false,
          ),
        );
      } else {
        emit(state.copyWith(loading: false, isBlocked: false));
      }
    } on PlatformException catch (e) {
      _handlePurchaseError(e);
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

  void _handlePurchaseError(PlatformException e) {
    debugPrint(e.toString());

    final errorCode = PurchasesErrorHelper.getErrorCode(e);

    switch (errorCode) {
      case PurchasesErrorCode.purchaseCancelledError:
        emit(state.copyWith(loading: false, error: "Purchase was cancelled."));
        return;

      case PurchasesErrorCode.networkError:
        emit(
          state.copyWith(
            loading: false,
            error: "No internet connection. Please try again.",
          ),
        );
        return;

      case PurchasesErrorCode.storeProblemError:
        emit(
          state.copyWith(
            loading: false,
            error: "Store temporarily unavailable.",
          ),
        );
        return;

      case PurchasesErrorCode.purchaseNotAllowedError:
        emit(
          state.copyWith(
            loading: false,
            error: "Purchases are not allowed on this device.",
          ),
        );
        return;

      case PurchasesErrorCode.configurationError:
        emit(
          state.copyWith(
            loading: false,
            error: "Subscription service configuration issue.",
          ),
        );
        return;

      case PurchasesErrorCode.receiptAlreadyInUseError:
        emit(
          state.copyWith(
            loading: false,
            error:
                "This Apple/Google account is already linked with another account. Please login with the original account.",
          ),
        );
        return;

      default:
        emit(
          state.copyWith(
            loading: false,
            error: e.message ?? "Something went wrong",
          ),
        );
    }
  }

  // ================= DISPOSE =================
  @override
  Future<void> close() {
    if (!isClosed) {
      Purchases.removeCustomerInfoUpdateListener(_handleCustomerInfo);
    }
    return super.close();
  }
}
