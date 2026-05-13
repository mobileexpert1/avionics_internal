import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../OldSubs/subscriptionResponseModel.dart';
import '../SubscriptionDetailPlan/SubscriptionDetailPlanModel.dart';
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
  final Package? selectedPackage;
  final bool? isBlocked;
  final bool? waitingForBackendConfirmation;
  final bool? isComeFromProfile;

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
    this.selectedPackage,
    this.isBlocked,
    this.waitingForBackendConfirmation,
    this.isComeFromProfile,
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
    Package? selectedPackage,
    bool? isBlocked,
    bool? waitingForBackendConfirmation,
    bool? isComeFromProfile,
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
      selectedPackage: selectedPackage ?? this.selectedPackage,
      isBlocked: isBlocked ?? this.isBlocked,
      waitingForBackendConfirmation:
          waitingForBackendConfirmation ?? this.waitingForBackendConfirmation,
      isComeFromProfile: isComeFromProfile ?? this.isComeFromProfile,
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
