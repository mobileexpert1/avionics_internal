import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionDetailPlanState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  final Offerings? offerings;
  final Package? selectedPackage;

  SubscriptionDetailPlanState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.offerings,
    this.selectedPackage,
  });

  SubscriptionDetailPlanState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    Offerings? offerings,
    Package? selectedPackage,
  }) {
    return SubscriptionDetailPlanState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      offerings: offerings ?? this.offerings,
      selectedPackage: selectedPackage ?? this.selectedPackage,
    );
  }
}
