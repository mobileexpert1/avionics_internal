import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'AppleSubscriptionRepository.dart';
import 'AppleSubscriptionState.dart';

class AppleSubscriptionCubit extends Cubit<AppleSubscriptionState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const _productIds = {
    'premium_subscription_monthly_iOS_Seven_Free_Days',
    'premium_subscription_yearly_iOS_Seven_Free_Days',
  };

  // static const _androidProductIds = {
  //   'premium-monthly',
  //   'premium-yearly',
  // };

  final Set<String> _androidProductIds = {
    'avioflai_premium',
    'avioflai_premium_yearly',
  };

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  AppleSubscriptionCubit() : super(AppleSubscriptionState()) {
    _initStore();
  }

  /// Initialize Store + Product Loading
  Future<void> _initStore() async {
    emit(state.copyWith(loading: true));
    final isAvailable = await _iap.isAvailable();
    print("App Store Available: $isAvailable");

    emit(state.copyWith(storeAvailable: isAvailable));

    if (!isAvailable) {
      emit(state.copyWith(loading: false, error: "App Store is not available"));
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (err) {
        emit(
          state.copyWith(loading: false, error: "Purchase stream error: $err"),
        );
      },
    );

    emit(state.copyWith(loading: true));
    await _loadProducts();
  }

  Future<void> restorePastPurchases() async {
    emit(state.copyWith(loading: true));
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Failed to restore purchases: $e',
        ),
      );
    }
  }

  /// Load available products from App Store
  Future<void> _loadProducts() async {
    try {
      emit(state.copyWith(loading: true));
      //final response = await _iap.queryProductDetails(_productIds);
      final response = await _iap.queryProductDetails(
        Platform.isIOS ? _productIds : _androidProductIds,
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

  /// User selects a plan
  void selectPlan(ProductDetails product) {
    emit(state.copyWith(selectedProduct: product));
  }

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

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      print(
        "Purchase update: ${purchase.productID}, Status: ${purchase.status}",
      );

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          try {
            _iap.completePurchase(purchase);

            print(
              "Server verification data: ${purchase.verificationData.serverVerificationData}",
            );
            print(
              "Local verification data: ${purchase.verificationData.localVerificationData}",
            );
            print("Source: ${purchase.verificationData.source}");

            // Call API regardless of flow
            await AppleSubscriptionRepository().postSubscriptionApi(
              token: purchase.verificationData.serverVerificationData,
              selectedSubscritionId: purchase.productID,
              platform: Platform.isIOS ? "ios" : "android",
              packageName: Platform.isAndroid ? "com.avioflai.aviation" : "",
            );

            emit(
              state.copyWith(
                purchased: true,
                loading: false,
                status: CommonApiStatus.success,
                activeProductId: purchase.productID,
              ),
            );
          } catch (e) {
            emit(state.copyWith(loading: false, error: e.toString()));
          }
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

  /// Restore previous purchases (manual trigger)
  Future<void> restorePurchases() async {
    print("Restoring purchases...");
    try {
      await _iap.restorePurchases();
    } catch (e) {
      emit(state.copyWith(error: "Restore failed: $e"));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
