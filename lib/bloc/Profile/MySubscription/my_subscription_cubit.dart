import 'dart:io';

import 'package:avionics_internal/bloc/Profile/MySubscription/my_subscription_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'my_subscription_model.dart';
import 'my_subscription_state.dart';

class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  final MySubscriptionRepository repository;

  MySubscriptionCubit({MySubscriptionRepository? repository})
    : repository = repository ?? MySubscriptionRepository(),
      super(MySubscriptionState());

  bool _isRequestInProgress = false;

  Future<void> loadSubscriptionsHistory({
    required BuildContext context,
    String? query,
    int? page,
    bool isLoadMore = false,
  })  async {
    if (await InternetConnection().hasInternetAccess) {
      if (_isRequestInProgress) return;

      if (isLoadMore && !state.hasNextPage) {
        return;
      }

      _isRequestInProgress = true;

      final nextPage = page ?? (isLoadMore ? state.currentPage + 1 : 1);

      debugPrint(
        'Loading Subscription Page => $nextPage '
        'isLoadMore => $isLoadMore',
      );

      if (isLoadMore) {
        emit(state.copyWith(isFetchingMore: true));
      } else {
        emit(
          state.copyWith(
            isLoading: true,
            isSuccess: false,
            status: CommonApiStatus.initial,
            currentPage: 1,
          ),
        );
      }

      try {
        final subscriptionData = await repository.getAllSubscriptionDetails(
          nextPage,
        );

        // Existing old subscriptions from previous pages
        final existingOldSubscriptions = isLoadMore
            ? (state.subscriptionData?.data.old ?? [])
            : <MySubscriptionItem>[];

        // New subscriptions from current API page
        final newOldSubscriptions = subscriptionData.data.old;

        // Merge old + new
        final combinedSubscriptions = [
          ...existingOldSubscriptions,
          ...newOldSubscriptions,
        ];

        // Remove duplicate IDs
        final uniqueMap = {
          for (final item in combinedSubscriptions) item.id: item,
        };

        final uniqueOldSubscriptions = uniqueMap.values.toList();

        // Update results/data
        final updatedData = subscriptionData.data.copyWith(
          old: uniqueOldSubscriptions,
        );

        // Update complete response
        final updatedSubscriptionData = subscriptionData.copyWith(
          data: updatedData,
        );

        _isRequestInProgress = false;

        emit(
          state.copyWith(
            subscriptionData: updatedSubscriptionData,

            currentPage: nextPage,

            hasNextPage: subscriptionData.next != null,

            isLoading: false,
            isFetchingMore: false,

            isSuccess: true,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        _isRequestInProgress = false;

        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(
          state.copyWith(
            isLoading: false,
            isFetchingMore: false,
            isSuccess: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      _isRequestInProgress = false;

      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadSubscriptionsHistory(
            page: page,
            isLoadMore: isLoadMore, context: context,
          );
        },
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

  String getPackageDescriptionTitle(
    String description,
    bool isComeFromHistory,
  ) {
    final lowerDescription = description.toLowerCase();

    final packType = lowerDescription.contains('credit') ? 'Credit' : 'Token';

    if (lowerDescription.contains('small')) {
      return isComeFromHistory ? 'Light Add-on $packType' : 'Light (L)';
    }

    if (lowerDescription.contains('medium')) {
      return isComeFromHistory ? 'Medium Add-on $packType' : 'Medium (M)';
    }

    if (lowerDescription.contains('large')) {
      return isComeFromHistory ? 'Heavy Add-on $packType' : 'Heavy (H)';
    }

    print(description);
    return description;
  }
}
