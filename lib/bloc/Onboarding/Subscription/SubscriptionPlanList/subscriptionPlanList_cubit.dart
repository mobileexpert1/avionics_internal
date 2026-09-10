import 'package:avionics_internal/bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_repository.dart';
import 'package:avionics_internal/bloc/Onboarding/Subscription/SubscriptionPlanList/subscriptionPlanList_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  Future<void> loadPlans(bool isForBasic) async {
    emit(SubscriptionLoading());

    try {
      final plans = await SubscriptionRepository().getPlans(isForBasic);
      emit(SubscriptionLoaded(plans: plans, selectedIndex: 0));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }

  void selectDuration(int index) {
    if (state is! SubscriptionLoaded) return;

    final currentState = state as SubscriptionLoaded;

    emit(currentState.copyWith(selectedIndex: index));
  }
}
