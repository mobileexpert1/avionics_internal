import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'AppleSubscriptionState.dart';

class AppleSubscriptionCubit extends Cubit<AppleSubscriptionState> {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const _productIds = {
    'premium_subscription_monthly_iOS_Seven_Free_Days',
    'premium_subscription_yearly_iOS_Seven_Free_Days',
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

    await _loadProducts();
  }

  /// Load available products from App Store
  Future<void> _loadProducts() async {
    try {
      final response = await _iap.queryProductDetails(_productIds);

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

  /// Initiate purchase
  void buySelected() {
    final selected = state.selectedProduct;
    if (selected == null) {
      emit(state.copyWith(error: "No subscription selected"));
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: selected);
    print("Initiating purchase for: ${selected.id}");
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Handle purchase stream updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      print(
        "Purchase update: ${purchase.productID}, Status: ${purchase.status}",
      );
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _iap.completePurchase(purchase);
          emit(state.copyWith(purchased: true));
          break;
        case PurchaseStatus.error:
          emit(state.copyWith(error: purchase.error?.message));
          break;
        case PurchaseStatus.pending:
          // You may optionally emit loading state here
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
