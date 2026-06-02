import '../../../Profile/MySubscription/my_subscription_model.dart';

class SubscriptionBuyPlanStateModel {
  final String detail;
  final SubscriptionData? data;
  final MySubscriptionItem? upcoming;
  final String? session;

  SubscriptionBuyPlanStateModel({
    required this.detail,
    required this.data,
    required this.upcoming,
    required this.session,
  });

  factory SubscriptionBuyPlanStateModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionBuyPlanStateModel(
      detail: json['detail'] ?? '',
      data: json['data'] != null
          ? SubscriptionData.fromJson(json['data'])
          : null,
      upcoming: json['upcoming'] != null
          ? MySubscriptionItem.fromJson(json['upcoming'])
          : null,
      session: json['session'] ?? '',
    );
  }
}

class SubscriptionData {
  final String userId;
  final String platform;
  final String productId;
  final String? purchaseToken;
  final String originalTransactionId;
  final String status;
  final String type;
  final String startDate;
  final String expiryDate;

  final String startDateLocal;
  final String expiryDateLocal;

  final String? cancellationDate;
  final String currency;
  final String price;
  final String appTransactionId;

  SubscriptionData({
    required this.userId,
    required this.platform,
    required this.productId,
    this.purchaseToken,
    required this.originalTransactionId,
    required this.status,
    required this.type,
    required this.startDate,
    required this.expiryDate,
    required this.startDateLocal,
    required this.expiryDateLocal,

    this.cancellationDate,
    required this.currency,
    required this.price,
    required this.appTransactionId,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    final startDate = json['start_date'] ?? '';
    final expiryDate = json['expiry_date'] ?? '';

    return SubscriptionData(
      userId: json['user_id'] ?? '',
      platform: json['platform'] ?? '',
      productId: json['product_id'] ?? '',
      purchaseToken: json['purchase_token'],
      originalTransactionId: json['original_transaction_id'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      startDate: startDate,
      expiryDate: expiryDate,
      cancellationDate: json['cancellation_date'],
      currency: json['currency'] ?? '',
      price: json['price'] ?? '',
      appTransactionId: json['app_transaction_id'] ?? '',

      startDateLocal: convertUtcToLocal24Hour(startDate),
      expiryDateLocal: convertUtcToLocal24Hour(expiryDate),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'platform': platform,
      'product_id': productId,
      'purchase_token': purchaseToken,
      'original_transaction_id': originalTransactionId,
      'status': status,
      'type': type,
      'start_date': startDate,
      'expiry_date': expiryDate,
      'cancellation_date': cancellationDate,
      'currency': currency,
      'price': price,
      'app_transaction_id': appTransactionId,
    };
  }
}
