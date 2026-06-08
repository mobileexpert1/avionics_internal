import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'gameBadges_model.dart';
import 'gameBadges_repository.dart';
import 'gameBadges_state.dart';

class BadgesCubit extends Cubit<BadgesState> {
  BadgesCubit(BuildContext context) : super(BadgesState());

  Future<void> loadBadges({
    String? selectedTab,
    required BuildContext context,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      if (selectedTab == null || selectedTab.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            badges: [],
            selectedTab: selectedTab ?? '',
            status: CommonApiStatus.initial,
          ),
        );
        return;
      }

      emit(state.copyWith(isLoading: true, status: CommonApiStatus.submitting));

      try {
        BadgeResponse response;

        switch (selectedTab) {
          case "Quiz":
            response = await BadgesRepository().getQuizBadges();
            break;
          case "One Word":
            response = await BadgesRepository().getOneWordBadges();
            break;
          case "Black Box":
            response = await BadgesRepository().getBlackBoxBadges();
            break;
          case "Calculations":
            response = await BadgesRepository().getCalculationBadges();
            break;
          default:
            emit(
              state.copyWith(
                isLoading: false,
                isSuccess: false,
                badges: [],
                selectedTab: selectedTab,
                totalPoints: 0,
                status: CommonApiStatus.initial,
              ),
            );
            return;
        }

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            badges: response.data,
            selectedTab: selectedTab,
            totalPoints: response.totalEarnPoint,
            status: CommonApiStatus.success,
          ),
        );
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: e.toString(),
            status: CommonApiStatus.failure,
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadBadges(selectedTab: selectedTab, context: context),
      );
    }
  }

  Future<void> changeTab(
    String tabName, {
    required BuildContext context,
  }) async {
    emit(state.copyWith(selectedTab: tabName));
    await loadBadges(selectedTab: tabName, context: context);
  }
}
