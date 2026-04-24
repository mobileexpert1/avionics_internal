import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Helpers/push_notifications/LocalNotificationHelper.dart';
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
  final Set<String> _processedTransactions = {};
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

    emit(state.copyWith(loading: true));

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      print(" ${product.id}");
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
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (purchases.isEmpty) return;

      final latest = purchases
          .where(
            (p) =>
                p.status == PurchaseStatus.purchased ||
                p.status == PurchaseStatus.restored,
          )
          .toList()
          .last;

      final token = latest.verificationData.serverVerificationData;

      final decoded = decodeJwt(token);

      final transactionId = decoded['transactionId'];

      print("Latest Transaction ID: $transactionId");

      if (_processedPurchaseIds.contains(transactionId)) {
        print("Already processed");
        return;
      }

      _processedPurchaseIds.add(transactionId);

      print("Purchase Event -> ${latest.productID} | ${latest.status}");

      switch (latest.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handlePurchase(latest, decoded);
          break;

        case PurchaseStatus.pending:
          emit(state.copyWith(loading: true));
          break;

        case PurchaseStatus.error:
          emit(
            state.copyWith(
              loading: false,
              error: latest.error?.message ?? "Purchase failed",
            ),
          );
          break;

        case PurchaseStatus.canceled:
          emit(state.copyWith(loading: false, error: "Purchase cancelled"));
          break;
      }
    });
  }

  Future<void> _handlePurchase(
    PurchaseDetails purchase,
    Map<String, dynamic> decoded,
  ) async {
    final transactionId = decoded['transactionId'];

    if (_processedTransactions.contains(transactionId)) {
      print("Duplicate transaction ignored: $transactionId");
      return;
    }

    _processedTransactions.add(transactionId);

    try {
      final token = purchase.verificationData.serverVerificationData;

      final productId = decoded['productId'];

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      await AppleSubscriptionRepository().postSubscriptionApi(
        token: token,
        selectedSubscriptionId: purchase.productID,
        platform: Platform.isIOS ? "ios" : "android",
        packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
      );

      final backendResponse = await AppleSubscriptionRepository()
          .getSubscriptionDetails();

      if (backendResponse.data?.status == "expired") {
        _processedTransactions.clear();
        _processedPurchaseIds.clear();
      }

      emit(
        state.copyWith(
          purchased: backendResponse.data?.status == "active",
          loading: false,
          status: CommonApiStatus.success,
          activeProductId: productId,
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

Map<String, dynamic> decodeJwt(String token) {
  final parts = token.split('.');

  if (parts.length != 3) {
    throw Exception('Invalid token');
  }

  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final decodedBytes = base64Url.decode(normalized);
  final decodedString = utf8.decode(decodedBytes);
  return jsonDecode(decodedString);
}

String formatDate(int millis) {
  final date = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true)
      .toLocal();

  return "${date.day}/${date.month}/${date.year} "
      "${date.hour}:${date.minute}";
}