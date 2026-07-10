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
    int? selectedTab,
    required BuildContext context,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      if (selectedTab == null) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            badges: [],
            selectedTab: selectedTab ?? 0,
            status: CommonApiStatus.initial,
          ),
        );
        return;
      }

      emit(state.copyWith(isLoading: true, status: CommonApiStatus.submitting));

      try {
        BadgeResponse response;

        switch (selectedTab) {
          case 0:
            response = await BadgesRepository().getQuizBadges();
            break;
          case 1:
            response = await BadgesRepository().getOneWordBadges();
            break;
          case 2:
            response = await BadgesRepository().getBlackBoxBadges();
            break;
          case 3:
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


  Future<void> changeTab(int tabName, {required BuildContext context}) async {
    emit(state.copyWith(selectedTab: tabName));
    await loadBadges(selectedTab: tabName, context: context);
  }
}
