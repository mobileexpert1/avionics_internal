import 'dart:io';

import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'my_subscription_model.dart';
import 'my_subscription_state.dart';

class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  final MySubscriptionRepository repository;

  MySubscriptionCubit({MySubscriptionRepository? repository})
    : repository = repository ?? MySubscriptionRepository(),
      super(MySubscriptionState());

  Future<void> loadSubscriptionsHistory() async {
    emit(state.copyWith(isLoading: true, status: CommonApiStatus.initial));

    try {
      final subscriptionData = await repository.getAllSubscriptionDetails();

      emit(
        state.copyWith(
          subscriptionData: subscriptionData,
          isLoading: false,
          isSuccess: true,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          subscriptionData:null,
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
          status: CommonApiStatus.failure,
        ),
      );
    }
  }

  Future<void> guideUserToCancelSubscription() async {
       try {
      final url = Platform.isIOS
          ? 'https://apps.apple.com/account/subscriptions'
          : 'https://play.google.com/store/account/subscriptions';

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(
        state.copyWith(errorMessage: "Failed to open subscription page: $e"),
      );
    }
  }

  void selectSubscription(MySubscriptionItem item) {
    emit(state.copyWith(selectedSubscription: item));
  }
}
