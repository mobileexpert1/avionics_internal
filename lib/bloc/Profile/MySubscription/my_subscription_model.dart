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

  MySubscriptionData({this.current, this.upcoming, required this.old});

  factory MySubscriptionData.fromJson(Map<String, dynamic> json) {
    return MySubscriptionData(
      current:
          json['current'] != null &&
              json['current'] is Map &&
              (json['current'] as Map).isNotEmpty
          ? MySubscriptionItem.fromJson(json['current'])
          : null,

      upcoming:
          json['upcoming'] != null &&
              json['upcoming'] is Map &&
              (json['upcoming'] as Map).isNotEmpty
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
  final String type;
  final String platform;

  final String startDate;
  final String expiryDate;

  final String startDateLocal;
  final String expiryDateLocal;

  final String? cancellationDate;

  final String currency;
  final String price;

  final dynamic priceInPurchasedCurrency;

  final double taxPercentage;
  final double taxAmount;

  final String originalTransactionId;

  final MySubscriptionPlanModel plan;

  final String currencySymbol;

  final List<AddOnModel> addOnPacksModel;

  MySubscriptionItem({
    required this.id,
    required this.status,
    required this.type,
    required this.platform,
    required this.startDate,
    required this.expiryDate,
    required this.startDateLocal,
    required this.expiryDateLocal,
    required this.cancellationDate,
    required this.currency,
    required this.price,
    required this.priceInPurchasedCurrency,
    required this.taxPercentage,
    required this.taxAmount,
    required this.originalTransactionId,
    required this.plan,
    required this.currencySymbol,
    required this.addOnPacksModel,
  });

  factory MySubscriptionItem.fromJson(Map<String, dynamic> json) {
    final currencyCode = json['currency'] ?? '';

    final startDate = json['start_date'] ?? '';

    final expiryDate = json['expiry_date'] ?? '';

    return MySubscriptionItem(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      platform: json['platform'] ?? '',

      startDate: startDate,
      expiryDate: expiryDate,

      startDateLocal: convertUtcToLocal24Hour(startDate),
      expiryDateLocal: convertUtcToLocal24Hour(expiryDate),

      cancellationDate: json['cancellation_date'],

      currency: currencyCode,

      price: json['price']?.toString() ?? '',

      priceInPurchasedCurrency: json['price_in_purchased_currency'],

      taxPercentage: (json['tax_percentage'] as num?)?.toDouble() ?? 0.0,

      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,

      originalTransactionId: json['original_transaction_id'] ?? '',

      plan: MySubscriptionPlanModel.fromJson(json['plan'] ?? {}),

      currencySymbol: getCurrencySymbol(currencyCode),

      addOnPacksModel:
          ((json['add_on'] as List<dynamic>?)
                    ?.map((e) => AddOnModel.fromJson(e))
                    .toList() ??
                [])
            ..sort((a, b) => b.purchaseDateTime.compareTo(a.purchaseDateTime)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'type': type,
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
      'add_on': addOnPacksModel.map((e) => e.toJson()).toList(),
    };
  }
}

String getCurrencySymbol(String currencyCode) {
  return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
}

class AddOnModel {
  final String id;
  final String platform;
  final String currency;

  final String price;
  final String priceInPurchasedCurrency;

  final String purchaseDate;
  final String purchaseDateLocal;

  final double taxPercentage;
  final double taxAmount;

  final String type;

  final int credit;
  final int token;
  final String currencySymbol;
  final String planName;

  AddOnModel({
    required this.id,
    required this.platform,
    required this.currency,
    required this.price,
    required this.priceInPurchasedCurrency,
    required this.purchaseDate,
    required this.purchaseDateLocal,
    required this.taxPercentage,
    required this.taxAmount,
    required this.type,
    required this.credit,
    required this.token,
    required this.currencySymbol,
    required this.planName,
  });

  DateTime get purchaseDateTime =>
      DateFormat('dd MMM yyyy, HH:mm').parse(purchaseDate);

  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    final currencyCode = json['currency'] ?? '';
    final purchaseDateLocal = json['purchase_date'] ?? '';

    return AddOnModel(
      id: json['id'] ?? '',
      platform: json['platform'] ?? '',
      currency: currencyCode,

      price: json['price']?.toString() ?? '',

      priceInPurchasedCurrency:
          json['price_in_purchased_currency']?.toString() ?? '',

      purchaseDate: json['purchase_date'] ?? '',
      purchaseDateLocal: convertUtcToLocal24Hour(purchaseDateLocal),

      taxPercentage: (json['tax_percentage'] as num?)?.toDouble() ?? 0.0,

      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,

      type: json['type'] ?? '',

      credit: json['credit'] ?? 0,

      token: json['token'] ?? 0,
      currencySymbol: getCurrencySymbol(currencyCode),
      planName: json['plan_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'currency': currency,
      'price': price,
      'price_in_purchased_currency': priceInPurchasedCurrency,
      'purchase_date': purchaseDate,
      'tax_percentage': taxPercentage,
      'tax_amount': taxAmount,
      'type': type,
      'credit': credit,
      'token': token,
      'plan_name': planName,
    };
  }
}

class PackageCount {
  int small;
  int medium;
  int large;

  PackageCount({this.small = 0, this.medium = 0, this.large = 0});

  @override
  String toString() {
    return 'Small: $small, Medium: $medium, Large: $large';
  }
}

PackageCount getCreditPackageCount(List<AddOnModel> addOns) {
  final count = PackageCount();
  for (final item in addOns) {
    final planName = item.planName.toLowerCase();
    if (planName.contains('credit small')) {
      count.small++;
    } else if (planName.contains('credit medium')) {
      count.medium++;
    } else if (planName.contains('credit large')) {
      count.large++;
    }
  }
  return count;
}

PackageCount getTokenPackageCount(List<AddOnModel> addOns) {
  final count = PackageCount();
  for (final item in addOns) {
    final planName = item.planName.toLowerCase();
    if (planName.contains('token small')) {
      count.small++;
    } else if (planName.contains('token medium')) {
      count.medium++;
    } else if (planName.contains('token large')) {
      count.large++;
    }
  }
  return count;
}

String convertUtcToLocal24Hour(String utcDate) {
  try {
    final cleanDate = utcDate.replaceAll(" UTC", "").trim();

    final formattedDate = cleanDate
        .split(' ')
        .asMap()
        .entries
        .map((entry) {
          if (entry.key == 1) {
            final month = entry.value;
            return month[0].toUpperCase() + month.substring(1).toLowerCase();
          }
          return entry.value;
        })
        .join(' ');

    final utcDateTime = DateFormat(
      'dd MMM yyyy, HH:mm',
    ).parseUtc(formattedDate);

    final localDateTime = utcDateTime.toLocal();

    return DateFormat('dd MMM yyyy, HH:mm').format(localDateTime);
  } catch (e) {
    return utcDate;
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

enum BillingHistoryEntryType { subscription, addOn }

class BillingHistoryEntry {
  final BillingHistoryEntryType entryType;
  final MySubscriptionItem? subscriptionItem;
  final AddOnModel? addOnItem;

  BillingHistoryEntry.subscription(this.subscriptionItem)
    : entryType = BillingHistoryEntryType.subscription,
      addOnItem = null;

  BillingHistoryEntry.addOn(this.addOnItem)
    : entryType = BillingHistoryEntryType.addOn,
      subscriptionItem = null;

  bool get isAddOn => entryType == BillingHistoryEntryType.addOn;

  bool get isSubscription => entryType == BillingHistoryEntryType.subscription;
}

List<BillingHistoryEntry> buildFlatBillingHistory(
  List<MySubscriptionItem> items,
) {
  final List<BillingHistoryEntry> result = [];

  for (final item in items) {
    result.add(BillingHistoryEntry.subscription(item));
    for (final addOn in item.addOnPacksModel) {
      result.add(BillingHistoryEntry.addOn(addOn));
    }
  }
  return result;
}
