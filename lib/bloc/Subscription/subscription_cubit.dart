import 'package:avionics_internal/Home/RootTabbar/RootTabbarScreen.dart';
import 'package:avionics_internal/bloc/Subscription/subscription_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'subscription_repository.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(BuildContext context)
    : super(SubscriptionInitial(selectedId: '', subscriptionList: [])) {
    getSubscriptions(context);
  }

  Future<void> getSubscriptions(BuildContext context) async {
    emit(
      SubscriptionInitial(
        selectedId: '',
        subscriptionList: [],
        isLoading: true,
        status: CommonApiStatus.submitting,
      ),
    );

    try {
      final subscriptionsList = await SubscriptionRepository()
          .fetchSubscriptions();
      final firstId = subscriptionsList.first.id;

      emit(
        SubscriptionInitial(
          selectedId: firstId,
          subscriptionList: subscriptionsList,
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        SubscriptionInitial(
          selectedId: '',
          subscriptionList: [],
          isLoading: false,
          isSuccess: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> submitSubscriptionApi(BuildContext context) async {
    final currentState = state;
    if (currentState is SubscriptionInitial) {
      final selectedFinalItem = currentState.subscriptionList.firstWhere(
        (item) => item.id == currentState.selectedId,
      );

      emit(
        currentState.copyWith(
          isLoading: true,
          isSuccess: false,
          status: CommonApiStatus.submitting,
        ),
      );

      try {
        await SubscriptionRepository().postSubscriptionApi(
          subscription_id: selectedFinalItem.id,
        );

        emit(
          currentState.copyWith(
            isLoading: false,
            isSuccess: true,
            status: CommonApiStatus.success,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RootTabbarscreen()),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(
          currentState.copyWith(
            isLoading: false,
            isSuccess: false,
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void selectOption(SubscriptionItemModel selectedItem) {
    final currentState = state;
    if (currentState is SubscriptionInitial) {
      emit(currentState.copyWith(selectedId: selectedItem.id));
    }
  }

  SubscriptionItemModel? get selectedItem {
    final currentState = state;
    if (currentState is SubscriptionInitial) {
      try {
        return currentState.subscriptionList.firstWhere(
          (item) => item.id == currentState.selectedId,
        );
      } catch (_) {}
    }
    return null;
  }
}
