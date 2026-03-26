import 'dart:async';
import 'dart:io';
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
  bool globalWebRedirectDone = false;
  Timer? _debounceTimer;
  List<PurchaseDetails> _pendingPurchases = [];
  bool _notificationShown = false;
  bool _isRestoring = false;
  final Set<String> _processedPurchaseIds = {};

  AppleSubscriptionCubit({bool autoRestore = false})
    : super(AppleSubscriptionState()) {
    _initStore(autoRestore: autoRestore);
  }

  // ---------------- INIT ----------------
  Future<void> _initStore({bool autoRestore = false}) async {
    emit(state.copyWith(loading: state.products.isEmpty));
    if (!kIsWeb) {
      _notificationShown = false;

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
    }
  }

  Future<void> handleWebRedirectionIfNeeded() async {
    if (globalWebRedirectDone) return;
    globalWebRedirectDone = true;

    final webSessionToken = await AppleSubscriptionRepository()
        .getSubscriptionSessionToken();

    if (webSessionToken.session.isEmpty) return;

    final callback = Uri.encodeComponent(Uri.base.toString());

    final url =
        "https://avionica.csdevhub.com/user-service/subscription/choose/${webSessionToken.session}?callback=$callback";

    print(url);

    final uri = Uri.parse(url);
    if (kIsWeb) {
      await launchUrl(uri, webOnlyWindowName: '_self');
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ---------------- PRODUCTS ----------------

  Future<void> _loadProducts() async {
    try {
      final productIds = kIsWeb
          ? <String>{}
          : Platform.isIOS
          ? iosProductIds
          : androidProductIds;

      final response = await _iap.queryProductDetails(productIds);

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
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final pending = [..._pendingPurchases];
      _pendingPurchases.clear();

      final Map<String, PurchaseDetails> uniquePurchases = {};

      for (final p in pending) {
        final key = p.purchaseID ?? p.verificationData.serverVerificationData;

        uniquePurchases[key] = p;
      }

      for (final purchase in uniquePurchases.values) {
        final purchaseKey =
            purchase.purchaseID ??
            purchase.verificationData.serverVerificationData;

        if (!_isRestoring && _processedPurchaseIds.contains(purchaseKey)) {
          continue;
        }

        _processedPurchaseIds.add(purchaseKey);

        print(
          "Purchase Event -> ${purchase.productID} | ${purchase.status} | $purchaseKey",
        );

        switch (purchase.status) {
          case PurchaseStatus.purchased:
            await _handleSuccess(purchase, purchaseKey);
            break;

          case PurchaseStatus.restored:
            await _handleRestore(purchase, purchaseKey);
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

          case PurchaseStatus.canceled:
            emit(state.copyWith(loading: false, error: "Purchase cancelled"));
            break;
        }
      }
    });
  }

  Future<void> _handleRestore(
    PurchaseDetails purchase,
    String purchaseKey,
  ) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      if (state.subscription?.status == "active") {
        emit(
          state.copyWith(
            purchased: true,
            loading: false,
            status: CommonApiStatus.success,
            activeProductId: purchase.productID,
          ),
        );
        return;
      }

      await AppleSubscriptionRepository().postSubscriptionApi(
        token: purchase.verificationData.serverVerificationData,
        selectedSubscritionId: purchase.productID,
        platform: Platform.isIOS ? "ios" : "android",
        packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
      );

      final backendResponse = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      emit(
        state.copyWith(
          purchased: backendResponse.data?.status == "active",
          loading: false,
          status: CommonApiStatus.success,
          activeProductId: purchase.productID,
          subscription: backendResponse.data,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: "Restore failed: $e"));
    }
  }

  // ---------------- SUCCESS HANDLING ----------------
  Future<void> _handleSuccess(
    PurchaseDetails purchase,
    String purchaseKey,
  ) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      await AppleSubscriptionRepository().postSubscriptionApi(
        token: purchase.verificationData.serverVerificationData,
        selectedSubscritionId: purchase.productID,
        platform: Platform.isIOS ? "ios" : "android",
        packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
      );

      final backendResponse = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      final resolvedProductId = _resolveActiveProductId(
        appleProductId: purchase.productID,
        backendSubscription: backendResponse.data,
      );

      if (!_notificationShown && !kIsWeb) {
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
    _isRestoring = true;
    _processedPurchaseIds.clear();
    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));
    try {
      await _iap.restorePurchases();

      Future.delayed(const Duration(seconds: 8), () {
        if (_isRestoring && !isClosed) {
          _isRestoring = false;
          emit(state.copyWith(loading: false));
        }
      });

    } catch (e) {
      _isRestoring = false;

      emit(
        state.copyWith(
          loading: false,
          error: "Restore failed: $e",
          status: CommonApiStatus.failure,
        ),
      );
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
    if (state.activeProductId == null || state.activeProductId!.isEmpty) {
      emit(state.copyWith(error: "No active subscription to cancel"));
      return;
    }

    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));

    try {
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
