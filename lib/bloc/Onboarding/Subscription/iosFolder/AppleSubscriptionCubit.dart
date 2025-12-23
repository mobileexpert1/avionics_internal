import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AppleSubscriptionRepository.dart';
import 'AppleSubscriptionState.dart';

class AppleSubscriptionCubit extends Cubit<AppleSubscriptionState> {
  final InAppPurchase _iap = InAppPurchase.instance;

  /// iOS Product IDs
  static const Set<String> _iosProductIds = {
    'premium_subscription_monthly_iOS_Seven_Free_Days',
    'premium_subscription_yearly_iOS_Seven_Free_Days',
  };

  /// Android Product IDs
  static const Set<String> _androidProductIds = {
    'avioflai_premium',
    'avioflai_premium_yearly',
  };

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Track handled purchases to avoid duplicate API calls
  final Set<String> _handledPurchases = {};

  AppleSubscriptionCubit() : super(AppleSubscriptionState()) {
    _initStore();
  }

  /// Initialize store and subscribe to purchase updates
  Future<void> _initStore() async {
    emit(state.copyWith(loading: true));

    final isAvailable = await _iap.isAvailable();
    emit(state.copyWith(storeAvailable: isAvailable));

    if (!isAvailable) {
      emit(state.copyWith(loading: false, error: "App Store is not available"));
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (err) => emit(
        state.copyWith(loading: false, error: "Purchase stream error: $err"),
      ),
    );

    await _loadProducts();
  }

  /// Load available products from store
  Future<void> _loadProducts() async {
    emit(state.copyWith(loading: true));

    try {
      final response = await _iap.queryProductDetails(
        Platform.isIOS ? _iosProductIds : _androidProductIds,
      );

      if (response.error != null) {
        emit(state.copyWith(loading: false, error: response.error!.message));
        return;
      }

      if (response.productDetails.isEmpty) {
        emit(state.copyWith(loading: false, error: "No products found."));
        return;
      }

      emit(state.copyWith(loading: false, products: response.productDetails));
    } catch (e) {
      emit(state.copyWith(loading: false, error: "Error loading products: $e"));
    }
  }

  /// User selects a subscription plan
  void selectPlan(ProductDetails product) {
    emit(state.copyWith(selectedProduct: product));
  }

  /// Initiate purchase
  void buySelected(BuildContext context) async {
    final selected = state.selectedProduct;

    if (selected == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No subscription selected")));
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: selected);
    print("Initiating purchase for: ${selected.id}");

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } on PlatformException catch (e) {
      final isCancelled = e.code == 'storekit2_purchase_cancelled';
      final message = isCancelled
          ? "Purchase cancelled by user."
          : "Purchase failed: ${e.message}";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error: $e")));
    }
  }

  /// Restore purchases manually
  Future<void> restorePurchases() async {
    print("Restoring purchases...");
    emit(state.copyWith(loading: true));

    try {
      await _iap.restorePurchases();
      await refreshSubscriptionFromBackend();
    } catch (e) {
      emit(state.copyWith(loading: false, error: "Restore failed: $e"));
    }
  }

  /// Handles purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      final key = "${purchase.productID}_${purchase.purchaseID ?? ''}";
      if (_handledPurchases.contains(key)) continue;
      _handledPurchases.add(key);

      print(
        "Purchase update: ${purchase.productID}, Status: ${purchase.status}",
      );

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchase);
          break;

        case PurchaseStatus.error:
          emit(
            state.copyWith(
              loading: false,
              error: purchase.error?.message ?? "Purchase failed.",
            ),
          );
          break;

        case PurchaseStatus.pending:
          emit(
            state.copyWith(
              loading: false,
              error: "Purchase pending confirmation from the server.",
            ),
          );
          break;

        default:
          break;
      }
    }
  }

  /// Handle successful purchase/restored purchase
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      print(
        "Server verification data: ${purchase.verificationData.serverVerificationData}",
      );
      print(
        "Local verification data: ${purchase.verificationData.localVerificationData}",
      );
      print("Source: ${purchase.verificationData.source}");

      // Call backend API to verify subscription
      emit(state.copyWith(loading: true));
      await AppleSubscriptionRepository().postSubscriptionApi(
        token: purchase.verificationData.serverVerificationData,
        selectedSubscriptionId: purchase.productID,
        platform: Platform.isIOS ? "ios" : "android",
        packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
      );

      // Fetch subscription details from backend
      emit(state.copyWith(loading: true));
      await getSubscriptionsFromBackendServer(purchase.productID);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// Fetch subscription details from backend
  Future<void> getSubscriptionsFromBackendServer(String activeProductId) async {
    emit(state.copyWith(loading: true, status: CommonApiStatus.initial));

    try {
      final response = await AppleSubscriptionRepository()
          .getSubscriptionDetails();
      final subscriptionData = response.data;

      emit(
        state.copyWith(
          subscription: subscriptionData,
          loading: false,
          status: CommonApiStatus.success,
          purchased: subscriptionData?.status == "active",
          activeProductId: activeProductId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CommonApiStatus.failure, error: e.toString()),
      );
    }
  }

  /// Refresh subscription (auto-renew / expiry)
  Future<void> refreshSubscriptionFromBackend() async {
    try {
      final response = await AppleSubscriptionRepository()
          .getSubscriptionDetails();
      final subscriptionData = response.data;
      emit(
        state.copyWith(
          subscription: subscriptionData,
          purchased: subscriptionData?.status == "active",
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
