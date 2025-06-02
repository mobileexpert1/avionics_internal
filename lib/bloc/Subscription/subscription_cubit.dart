import 'package:flutter_bloc/flutter_bloc.dart';

import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionInitial()); // Use const for the initial state

  void selectOption(SubscriptionOption option) {
    if (state is SubscriptionInitial) {
      final currentState = state as SubscriptionInitial;
      emit(currentState.copyWith(selectedOption: option));
    }
  }
}