import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'SubscriptionResponseModel.dart';

class SubscriptionModel {
  final String planName;
  final String price;
  final String billingDate;
  final bool isActive;

  SubscriptionModel({
    required this.planName,
    required this.price,
    required this.billingDate,
    required this.isActive,
  });
}

class BillingHistoryModel {
  final String title;
  final String date;
  final String amount;

  BillingHistoryModel({
    required this.title,
    required this.date,
    required this.amount,
  });
}

class SubscriptionBuyPlanState {
  final bool isUserAlreadyPremium;
  final bool storeAvailable;
  final bool loading;
  final bool purchased;
  final bool isProUser;
  final String? error;
  final CommonApiStatus status;
  final String? activeProductId;
  final SubscriptionBuyPlanStateModel? subscription;
  final Offerings? offerings;
  final bool? isBlocked;
  final bool? waitingForBackendConfirmation;
  final bool? isComeFromProfile;

  final List<Package> subscriptionPackages;
  final List<Package> consumablePackages;
  final Package? selectedConsumablePackage;
  final Package? selectedPackage;
  final bool consumablePurchased;


  SubscriptionBuyPlanState({
    this.isUserAlreadyPremium = false,
    this.storeAvailable = false,
    this.loading = false,
    this.purchased = false,
    this.isProUser = false,
    this.error,
    this.status = CommonApiStatus.initial,
    this.activeProductId,
    this.subscription,
    this.offerings,
    this.isBlocked,
    this.waitingForBackendConfirmation,
    this.isComeFromProfile,

    this.selectedPackage,
    this.subscriptionPackages = const [],
    this.consumablePackages = const [],
    this.selectedConsumablePackage,
    this.consumablePurchased = false,
  });

  SubscriptionBuyPlanState copyWith({
    bool? storeAvailable,
    bool? isUserAlreadyPremium,
    bool? loading,
    bool? purchased,
    bool? isProUser,
    String? error,
    CommonApiStatus? status,
    String? activeProductId,
    SubscriptionBuyPlanStateModel? subscription,
    Offerings? offerings,
    bool? isBlocked,
    bool? waitingForBackendConfirmation,
    bool? isComeFromProfile,

    Package? selectedPackage,
    List<Package>? subscriptionPackages,
    List<Package>? consumablePackages,
    Package? selectedConsumablePackage,
    bool? consumablePurchased,

  }) {
    return SubscriptionBuyPlanState(
      isUserAlreadyPremium: isUserAlreadyPremium ?? this.isUserAlreadyPremium,
      subscription: subscription ?? this.subscription,
      storeAvailable: storeAvailable ?? this.storeAvailable,
      loading: loading ?? this.loading,
      purchased: purchased ?? this.purchased,
      isProUser: isProUser ?? this.isProUser,
      error: error,
      status: status ?? this.status,
      activeProductId: activeProductId,
      offerings: offerings ?? this.offerings,
      isBlocked: isBlocked ?? this.isBlocked,
      waitingForBackendConfirmation:
          waitingForBackendConfirmation ?? this.waitingForBackendConfirmation,
      isComeFromProfile: isComeFromProfile ?? this.isComeFromProfile,

      subscriptionPackages: subscriptionPackages ?? this.subscriptionPackages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      consumablePackages: consumablePackages ?? this.consumablePackages,
      selectedConsumablePackage:
          selectedConsumablePackage ?? this.selectedConsumablePackage,
      consumablePurchased:
      consumablePurchased ??
          this.consumablePurchased,
    );
  }

  final features = const [
    'Aircraft Encyclopedia',
    'Live Aircraft Tracking',
    'Compare Models',
    'Filter, Search & Save',
    'AskWILCO AI Assistant',
    'Learning Games',
    'Offline Access',
    'Priority Support',
    'Available on iOS & Android',
  ];
}
