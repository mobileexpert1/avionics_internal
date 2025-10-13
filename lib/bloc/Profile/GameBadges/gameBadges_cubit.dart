import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/constantImages.dart';
import 'gameBadges_model.dart';
import 'gameBadges_state.dart';

class BadgesCubit extends Cubit<BadgesState> {
  BadgesCubit() : super(BadgesState());


  final Map<String, List<BadgeModel>> _badgeCategories = {
    "Quiz": [
      BadgeModel(
        title: "Cloud Chaser",
        unlockAfterWins: 10,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
        isUnlocked: true,
      ),
      BadgeModel(
        title: "Jetstream Voyager",
        unlockAfterWins: 15,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
      BadgeModel(
        title: "Noctilucent Explorer",
        unlockAfterWins: 20,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
      BadgeModel(
        title: "Aurora Sentinel",
        unlockAfterWins: 25,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
      BadgeModel(
        title: "Space Shuttle",
        unlockAfterWins: 30,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
    ],
    "One Word": [
      BadgeModel(
        title: "Word Pilot",
        unlockAfterWins: 5,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
        isUnlocked: true,
      ),
      BadgeModel(
        title: "Lexicon Ace",
        unlockAfterWins: 10,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
    ],
    "Black Box": [
      BadgeModel(
        title: "Logic Flyer",
        unlockAfterWins: 8,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
      BadgeModel(
        title: "Critical Thinker",
        unlockAfterWins: 15,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
    ],
    "Calculations": [
      BadgeModel(
        title: "Math Aviator",
        unlockAfterWins: 10,
        image: CommonUi.setPngImage(AssetsPath.badgeimg),
      ),
    ],
  };


  Future<void> loadBadges({
    required int userWins,
    required int totalPoints,
  }) async {
    emit(state.copyWith(isLoading: true, status: CommonApiStatus.submitting));
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final currentBadges = _badgeCategories[state.selectedTab] ?? [];

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          badges: currentBadges,
          totalPoints: totalPoints,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "Failed to load badges",
          status: CommonApiStatus.failure,
        ),
      );
    }
  }

  void changeTab(String tab) {
    if (state.selectedTab == tab) return;

    final currentBadges = _badgeCategories[tab] ?? [];

    emit(
      state.copyWith(
        selectedTab: tab,
        badges: currentBadges,
        isLoading: false,
        isSuccess: true,
        status: CommonApiStatus.success,
      ),
    );
  }
}
