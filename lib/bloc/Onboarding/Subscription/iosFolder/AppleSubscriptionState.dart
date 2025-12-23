import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../subscriptionResponseModel.dart';

class AppleSubscriptionState {
  final bool storeAvailable;
  final bool loading;

  // Apple IAP
  final List<ProductDetails> products;
  final ProductDetails? selectedProduct;
  final bool purchased;

  // Backend subscription (data only)
  final SubscriptionData? subscription;
  final bool hasActiveSubscription;

  final String? error;
  final CommonApiStatus status;
  final String? activeProductId;

  AppleSubscriptionState({
    this.storeAvailable = false,
    this.loading = false,
    this.products = const [],
    this.selectedProduct,
    this.purchased = false,
    this.subscription,
    this.hasActiveSubscription = false,
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
    SubscriptionData? subscription,
    bool? hasActiveSubscription,
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
      subscription: subscription ?? this.subscription,
      hasActiveSubscription:
      hasActiveSubscription ?? this.hasActiveSubscription,
      error: error,
      status: status ?? this.status,
      activeProductId: activeProductId ?? this.activeProductId,
    );
  }
}
