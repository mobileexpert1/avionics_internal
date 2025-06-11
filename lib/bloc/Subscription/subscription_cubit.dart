import 'package:avionics_internal/bloc/Subscription/subscription_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'subscription_state.dart';
import 'subscription_repository.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {

  SubscriptionCubit() : super(SubscriptionState.initial());

  Future<void> submitSubscription() async {
    emit(state.copyWith(status: CommonApiStatus.submitting));
    try {
      final plans = await SubscriptionRepository().fetchSubscriptions();
      emit(state.copyWith(
        status: CommonApiStatus.success,
        plans: plans,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void selectOption(SubscriptionPlanModel option) {
    emit(state.copyWith(selectedOption: option));
  }


}
