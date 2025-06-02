import 'package:flutter_bloc/flutter_bloc.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionInitial());

  void selectOption(SubscriptionOption option) {
    emit(SubscriptionInitial(selectedOption: option));
  }
}
