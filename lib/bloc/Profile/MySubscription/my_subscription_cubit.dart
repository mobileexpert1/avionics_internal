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

  bool _isPaginationRunning = false;

  Future<void> loadSubscriptionsHistory({
    String? query,
    required BuildContext context,
    int page = 1,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (_isPaginationRunning) {
        debugPrint("Pagination already running");
        return;
      }

      if (!state.hasNextPage) {
        debugPrint("No more pages");
        return;
      }

      _isPaginationRunning = true;
    }

    if (!isLoadMore) {
      emit(
        state.copyWith(
          currentQuery: query ?? '',
          currentPage: 1,
          hasNextPage: false,
        ),
      );
    }

    if (await InternetConnection().hasInternetAccess) {
      if (isLoadMore) {
        _isPaginationRunning = true;

        emit(state.copyWith(isFetchingMore: true));
      } else {
        emit(state.copyWith(isLoading: true, currentPage: 1));
      }

      try {
        final nextPage = isLoadMore ? state.currentPage + 1 : 1;

        if (nextPage > state.totalPages) {
          return;
        }

        final subscriptionData = await repository.getAllSubscriptionDetails(
          nextPage,
        );

        if (subscriptionData.data.current == null) {
          emit(
            state.copyWith(
              hasNextPage: false,
              isLoading: false,
              isFetchingMore: false,
            ),
          );
          return;
        }

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

        // debugPrint("Existing: ${existingOldSubscriptions.length}");
        // debugPrint("New: ${newOldSubscriptions.length}");
        // debugPrint("Combined: ${combinedSubscriptions.length}");
        // debugPrint("Unique: ${uniqueOldSubscriptions.length}");

        emit(
          state.copyWith(
            subscriptionData: updatedSubscriptionData,

            currentPage: nextPage,

            hasNextPage: subscriptionData.next != null,

            isLoading: false,
            isFetchingMore: false,

            isSuccess: true,
            totalPages: updatedSubscriptionData.totalPages,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(state.copyWith(isLoading: false, isFetchingMore: false));
      } finally {
        _isPaginationRunning = false;
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          await loadSubscriptionsHistory(
            query: query,
            context: context,
            page: page,
            isLoadMore: isLoadMore,
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
