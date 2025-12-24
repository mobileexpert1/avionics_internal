import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';

class AppleSubscriptionState {
  final bool storeAvailable;
  final bool loading;
  final List<ProductDetails> products;
  final ProductDetails? selectedProduct;
  final bool purchased;
  final String? error;
  final CommonApiStatus status;
  final String? activeProductId;


  AppleSubscriptionState({
    this.storeAvailable = false,
    this.loading = false,
    this.products = const [],
    this.selectedProduct,
    this.purchased = false,
    this.error,
    this.status = CommonApiStatus.initial,
    this.activeProductId,
  });

  AppleSubscriptionState copyWith({
    bool? storeAvailable,
    bool? loading,
    List<ProductDetails>? products,
    ProductDetails? selectedProduct,
    bool? purchased,
    String? error,
    CommonApiStatus? status,
    String? activeProductId,
  }) {
    return AppleSubscriptionState(
      storeAvailable: storeAvailable ?? this.storeAvailable,
      loading: loading ?? this.loading,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      purchased: purchased ?? this.purchased,
      error: error,
      status: status ?? CommonApiStatus.initial,
      activeProductId: activeProductId,
    );
  }
}

