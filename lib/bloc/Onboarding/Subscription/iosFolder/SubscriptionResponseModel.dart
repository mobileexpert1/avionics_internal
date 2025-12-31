class SubscriptionResponseModel {
  final String detail;
  final SubscriptionData? data;

  SubscriptionResponseModel({required this.detail, required this.data});

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseModel(
      detail: json['detail'] ?? '',
      data: json['data'] != null
          ? SubscriptionData.fromJson(json['data'])
          : null,
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
    this.cancellationDate,
    required this.currency,
    required this.price,
    required this.appTransactionId,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      userId: json['user_id'] ?? '',
      platform: json['platform'] ?? '',
      productId: json['product_id'] ?? '',
      purchaseToken: json['purchase_token'],
      originalTransactionId: json['original_transaction_id'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      startDate: json['start_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cancellationDate: json['cancellation_date'],
      currency: json['currency'] ?? '',
      price: json['price'] ?? '',
      appTransactionId: json['app_transaction_id'] ?? '',
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

