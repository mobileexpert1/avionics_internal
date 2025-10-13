import '../../../Constants/ApiClass/ApiErrorModel.dart';
import 'gameBadges_model.dart';

class BadgesState {
  final List<BadgeModel> badges;
  final int totalPoints;
  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;
  final String selectedTab;

  BadgesState({
    this.badges = const [],
    this.totalPoints = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
    this.selectedTab = "Quiz",
  });

  BadgesState copyWith({
    List<BadgeModel>? badges,
    int? totalPoints,
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
    String? selectedTab,

  }) {
    return BadgesState(
      badges: badges ?? this.badges,
      totalPoints: totalPoints ?? this.totalPoints,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
