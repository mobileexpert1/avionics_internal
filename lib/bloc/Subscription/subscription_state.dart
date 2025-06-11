import 'package:avionics_internal/bloc/Subscription/subscription_model.dart';

enum CommonApiStatus { initial, submitting, success, failure }

class SubscriptionState {
  final CommonApiStatus status;
  final List<SubscriptionPlanModel> plans;
  final SubscriptionPlanModel? selectedOption;
  final String? errorMessage;

  SubscriptionState({
    required this.status,
    required this.plans,
    this.selectedOption,
    this.errorMessage,
  });

  factory SubscriptionState.initial() {
    return SubscriptionState(
      status: CommonApiStatus.initial,
      plans: [],
      selectedOption: null,
      errorMessage: null,
    );
  }

  SubscriptionState copyWith({
    CommonApiStatus? status,
    List<SubscriptionPlanModel>? plans,
    SubscriptionPlanModel? selectedOption,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      selectedOption: selectedOption ?? this.selectedOption,
      errorMessage: errorMessage,
    );
  }
}
