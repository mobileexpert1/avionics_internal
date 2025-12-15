import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'gameBadges_repository.dart';
import 'gameBadges_state.dart';
import 'gameBadges_model.dart';

class BadgesCubit extends Cubit<BadgesState> {
  BadgesCubit(BuildContext context) : super(BadgesState());

  Future<void> loadBadges({
    required int userWins,
    required int totalPoints,
    String? selectedTab,
    required BuildContext context,
  }) async {
    if (selectedTab == null || selectedTab.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        badges: [],
        totalPoints: totalPoints,
        selectedTab: selectedTab ?? '',
        status: CommonApiStatus.initial,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, status: CommonApiStatus.submitting));

    try {
      BadgeResponse response;

      switch (selectedTab) {
        case "Quiz":
          response = await BadgesRepository().getQuizBadges(
            userWins: userWins,
            totalPoints: totalPoints,
          );
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

          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            badges: [],
            totalPoints: totalPoints,
            selectedTab: selectedTab,
            status: CommonApiStatus.initial,
          ));
          return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          badges: response.data,
          totalPoints: response.totalEarnPoint ?? totalPoints,
          selectedTab: selectedTab,
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
  }


  /// Change Tab
  Future<void> changeTab(
      String tabName, {
        required int userWins,
        required int totalPoints,
        required BuildContext context,
      }) async {
    emit(state.copyWith(selectedTab: tabName));
    await loadBadges(
      userWins: userWins,
      totalPoints: totalPoints,
      selectedTab: tabName, context: context,
    );
  }
}
