import 'dart:async';
import 'dart:io';

import 'package:avionics_internal/Constants/ApiClass/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Helpers/push_notifications/LocalNotificationHelper.dart';
import '../subscriptionResponseModel.dart';
import 'AppleSubscriptionRepository.dart';
import 'AppleSubscriptionState.dart';

const Set<String> iosProductIds = {
  'premium_subscription_monthly_iOS_Seven_Free_Days',
  'premium_subscription_yearly_iOS_Seven_Free_Days',
};

const Set<String> androidProductIds = {
  'avioflai_premium',
  'avioflai_premium_yearly',
};

class AppleSubscriptionCubit extends Cubit<AppleSubscriptionState> {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  // Debounce timer for purchase updates
  bool _webRedirectDone = false;
  Timer? _debounceTimer;
  List<PurchaseDetails> _pendingPurchases = [];
  bool _notificationShown = false;

  AppleSubscriptionCubit({bool autoRestore = false})
    : super(AppleSubscriptionState()) {
    _initStore(autoRestore: autoRestore);
  }

  // ---------------- INIT ----------------

  Future<void> handleWebRedirectionIfNeeded() async {
    if (!kIsWeb || _webRedirectDone) return;
    _webRedirectDone = true;
    final token = await ApiService.getBearerToken();
    if (token != null) {
      print(
        "https://avionica.csdevhub.com/user-service/subscription/choose/$token",
      );
    }
    final url =
        "https://avionica.csdevhub.com/user-service/subscription/choose/$token";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _initStore({bool autoRestore = false}) async {
    emit(state.copyWith(loading: true));
    if (!kIsWeb) {
      _notificationShown = false;
      emit(state.copyWith(loading: true));

      final isAvailable = await _iap.isAvailable();
      emit(state.copyWith(storeAvailable: isAvailable));

      if (!isAvailable) {
        emit(state.copyWith(loading: false));
        return;
      }

      _purchaseSubscription = _iap.purchaseStream.listen(
        _onPurchaseUpdated,
        onError: (error) {
          emit(
            state.copyWith(
              loading: false,
              error: "Purchase stream error: $error",
            ),
          );
        },
      );

      await _loadProducts();

      if (autoRestore) {
        await restorePurchases();
      }
    } else {
      handleWebRedirectionIfNeeded();
    }
  }

  // ---------------- PRODUCTS ----------------

  Future<void> _loadProducts() async {
    try {
      final response = await _iap.queryProductDetails(
        Platform.isIOS ? iosProductIds : androidProductIds,
      );

      if (response.error != null) {
        emit(state.copyWith(loading: false, error: response.error!.message));
        return;
      }

      if (response.productDetails.isEmpty) {
        emit(state.copyWith(loading: false, error: "No subscriptions found"));
        return;
      }

      emit(state.copyWith(loading: false, products: response.productDetails));
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: "Failed to load subscriptions: $e",
        ),
      );
    }
  }

  // ---------------- PLAN SELECTION ----------------

  void selectPlan(ProductDetails product) {
    emit(state.copyWith(selectedProduct: product));
  }

  // ---------------- BUY ----------------

  Future<void> buySelected() async {
    final product = state.selectedProduct;

    if (product == null) {
      emit(state.copyWith(error: "No subscription selected"));
      return;
    }

    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } on PlatformException catch (e) {
      final cancelled = e.code == 'storekit2_purchase_cancelled';

      emit(
        state.copyWith(
          loading: false,
          error: cancelled
              ? "Purchase cancelled by user"
              : "Purchase failed: ${e.message}",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loading: false, error: "Unexpected purchase error: $e"),
      );
    }
  }

  // ---------------- PURCHASE STREAM (DEBOUNCED) ----------------

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    _pendingPurchases.addAll(purchases);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      final pending = List<PurchaseDetails>.from(_pendingPurchases);
      _pendingPurchases.clear();

      for (final purchase in pending) {
        // Skip already processed purchase
        if (state.activeProductId == purchase.productID &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)) {
          continue;
        }

        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await _handleSuccess(purchase);
            break;

          case PurchaseStatus.pending:
            emit(
              state.copyWith(loading: true, status: CommonApiStatus.initial),
            );
            break;

          case PurchaseStatus.error:
            emit(
              state.copyWith(
                loading: false,
                error: purchase.error?.message ?? "Purchase failed",
              ),
            );
            break;

          default:
            break;
        }
      }
    });
  }

  // ---------------- SUCCESS HANDLING ----------------

  Future<void> _handleSuccess(PurchaseDetails purchase) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      // Prevent duplicate backend calls
      if (state.activeProductId == purchase.productID) return;

      final product = state.products.firstWhere(
        (p) => p.id == purchase.productID,
      );

      String? startDate;
      if (purchase.transactionDate != null) {
        startDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(purchase.transactionDate!),
        ).toIso8601String();
      }
      await AppleSubscriptionRepository().postSubscriptionApi(
        token: purchase.verificationData.serverVerificationData,
        selectedSubscritionId: purchase.productID,
        platform: Platform.isIOS ? "ios" : "android",
        packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
        originalTransactionId: purchase.purchaseID,
        appTransactionId: purchase.purchaseID,
        type: "subscription",
        currency: product.currencyCode,
        price: product.price,
        startDate: startDate,
        expiryDate: "",
      );

      final backendResponse = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      final resolvedProductId = _resolveActiveProductId(
        appleProductId: purchase.productID,
        backendSubscription: backendResponse.data,
      );

      //  if (!kIsWeb) {
      if (!_notificationShown &&
          purchase.status == PurchaseStatus.purchased &&
          !kIsWeb) {
        _notificationShown = true;
        LocalNotificationHelper.show(
          title: "Subscription Active",
          body: "All premium features are unlocked",
          screenName: "profileSS",
        );
      }

      emit(
        state.copyWith(
          purchased: backendResponse.data?.status == "active",
          loading: false,
          status: CommonApiStatus.success,
          activeProductId: resolvedProductId,
          subscription: backendResponse.data,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: "Subscription verification failed: $e",
        ),
      );
    }
  }

  String _resolveActiveProductId({
    String? appleProductId,
    SubscriptionData? backendSubscription,
  }) {
    if (backendSubscription?.productId != null &&
        backendSubscription!.productId.isNotEmpty) {
      return backendSubscription.productId;
    }
    return appleProductId ?? "";
  }

  // ---------------- RESTORE ----------------

  Future<void> restorePurchases() async {
    emit(state.copyWith(loading: true));
    try {
      await _iap.restorePurchases();
    } catch (e) {
      emit(state.copyWith(loading: false, error: "Restore failed: $e"));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  // ---------------- CANCEL SUBSCRIPTION ----------------
  Future<void> guideUserToCancelSubscription() async {
    if (state.activeProductId == null) {
      emit(state.copyWith(error: "No active subscription to cancel"));
      return;
    }

    try {
      if (Platform.isIOS) {
        // Open Apple subscriptions page
        const url = 'https://apps.apple.com/account/subscriptions';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          emit(
            state.copyWith(error: "Cannot open App Store subscriptions page"),
          );
        }
      } else if (Platform.isAndroid) {
        // Open Google Play subscriptions page
        const url = 'https://play.google.com/store/account/subscriptions';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          emit(
            state.copyWith(error: "Cannot open Play Store subscriptions page"),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(error: "Failed to open subscription page: $e"));
    }
  }

  Future<void> cancelSubscription() async {
    if (state.activeProductId != null) {
      emit(state.copyWith(error: "No active subscription to cancel"));
      return;
    }

    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));

    try {
      // await AppleSubscriptionRepository().cancelSubscriptionApi(
      //   productId: state.activeProductId,
      //   platform: Platform.isIOS ? "ios" : "android",
      // );
      // Update Cubit state after cancellation
      emit(
        state.copyWith(
          purchased: false,
          activeProductId: "",
          subscription: null,
          loading: false,
          status: CommonApiStatus.success,
        ),
      );

      if (!kIsWeb) {
        LocalNotificationHelper.show(
          title: "Subscription Cancelled",
          body: "Your subscription has been cancelled successfully.",
          screenName: "profileSS",
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          status: CommonApiStatus.failure,
          error: "Failed to cancel subscription: $e",
        ),
      );
    }
  }

  // ---------------- BACKEND SYNC ----------------

  Future<void> getSubscriptionsFromBackendServer(String activeProductId) async {
    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));

    try {
      final response = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      emit(
        state.copyWith(
          subscription: response.data,
          purchased: response.data?.status == "active",
          activeProductId: activeProductId,
          loading: false,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          status: CommonApiStatus.failure,
          error: "Failed to fetch subscription: $e",
        ),
      );
    }
  }

  // ---------------- CLEANUP ----------------

  @override
  Future<void> close() {
    _purchaseSubscription?.cancel();
    _debounceTimer?.cancel();
    return super.close();
  }
}
