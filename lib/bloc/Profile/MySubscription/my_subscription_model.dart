import 'package:intl/intl.dart';

class MySubscriptionResponseModel {
  final String detail;
  final MySubscriptionData data;

  MySubscriptionResponseModel({required this.detail, required this.data});

  factory MySubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionResponseModel(
      detail: json['detail'] ?? '',
      data: MySubscriptionData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.toJson()};
  }
}

class MySubscriptionData {
  final MySubscriptionItem? current;
  final MySubscriptionItem? upcoming;
  final List<MySubscriptionItem> old;

  MySubscriptionData({
    required this.current,
    required this.upcoming,
    required this.old,
  });

  factory MySubscriptionData.fromJson(Map<String, dynamic> json) {
    return MySubscriptionData(
      current: json['current'] != null
          ? MySubscriptionItem.fromJson(json['current'])
          : null,
      upcoming: json['upcoming'] != null
          ? MySubscriptionItem.fromJson(json['upcoming'])
          : null,
      old:
          (json['old'] as List<dynamic>?)
              ?.map((e) => MySubscriptionItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current?.toJson(),
      'upcoming': upcoming?.toJson(),
      'old': old.map((e) => e.toJson()).toList(),
    };
  }
}

class MySubscriptionItem {
  final String id;
  final String status;
  final String platform;
  final String startDate;
  final String expiryDate;
  final String? cancellationDate;
  final String currency;
  final String price;
  final dynamic priceInPurchasedCurrency;
  final double taxPercentage;
   final double taxAmount;
  final String originalTransactionId;
  final MySubscriptionPlanModel plan;
  final String currencySymbol;

  MySubscriptionItem({
    required this.id,
    required this.status,
    required this.platform,
    required this.startDate,
    required this.expiryDate,
    required this.cancellationDate,
    required this.currency,
    required this.price,
    required this.priceInPurchasedCurrency,
    required this.taxPercentage,
    required this.taxAmount,
    required this.originalTransactionId,
    required this.plan,
    required this.currencySymbol,
  });

  factory MySubscriptionItem.fromJson(Map<String, dynamic> json) {
    final currencyCode = json['currency'] ?? '';

    return MySubscriptionItem(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      platform: json['platform'] ?? '',
      startDate: json['start_date'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      cancellationDate: json['cancellation_date'],
      currency: currencyCode,
      price: json['price'] ?? '',
      priceInPurchasedCurrency: json['price_in_purchased_currency'] ?? "",
      taxPercentage: (json['tax_percentage'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      originalTransactionId: json['original_transaction_id'] ?? '',
      plan: MySubscriptionPlanModel.fromJson(json['plan'] ?? {}),
      currencySymbol: getCurrencySymbol(currencyCode),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'platform': platform,
      'start_date': startDate,
      'expiry_date': expiryDate,
      'cancellation_date': cancellationDate,
      'currency': currency,
      'price': price,
      'price_in_purchased_currency': priceInPurchasedCurrency,
      'tax_percentage': taxPercentage,
      'tax_amount': taxAmount,
      'original_transaction_id': originalTransactionId,
      'plan': plan.toJson(),
      'currency_symbol': currencySymbol,
    };
  }

  static String getCurrencySymbol(String currencyCode) {
    return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
  }
}

class MySubscriptionPlanModel {
  final String id;
  final String name;
  final String billingCycle;

  MySubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.billingCycle,
  });

  factory MySubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';

    return MySubscriptionPlanModel(
      id: json['id'] ?? '',
      name: cleanTitle(name),
      billingCycle: json['billing_cycle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'billing_cycle': billingCycle};
  }

  static String cleanTitle(String title) {
    if (title.contains("(")) {
      title = title.substring(0, title.indexOf("(")).trim();
    }

    final lower = title.toLowerCase();

    if (lower.contains("monthly") || lower.contains("basic")) {
      return "Basic Plan";
    } else if (lower.contains("yearly") || lower.contains("premium")) {
      return "Premium Plan";
    }

    return title;
  }
}
