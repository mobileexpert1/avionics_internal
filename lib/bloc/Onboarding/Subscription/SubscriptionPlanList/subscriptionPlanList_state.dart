import 'package:avionics_internal/bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_model.dart';
import 'package:equatable/equatable.dart';

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;
  final int selectedIndex;

  SubscriptionLoaded({
    required this.plans,
    required this.selectedIndex,
  });

  SubscriptionLoaded copyWith({
    List<SubscriptionPlan>? plans,
    int? selectedIndex,
  }) {
    return SubscriptionLoaded(
      plans: plans ?? this.plans,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
    plans,
    selectedIndex,
  ];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}