import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'gameBadges_model.dart';

class BadgesRepository {
  /// ✅ Fetch Calculation Badges
  Future<BadgeResponse> getCalculationBadges() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.calculation}"
          "${ApiGameBadges.calculationBadges}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch calculation badges: $e");
    }
  }

  /// ✅ Fetch Quiz Badges
  Future<BadgeResponse> getQuizBadges({
    required int userWins,
    required int totalPoints,
  }) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.quiz}"
          "${ApiGameBadges.quizBadges}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch quiz badges: $e");
    }
  }

  /// ✅ Fetch Black Box Badges
  Future<BadgeResponse> getBlackBoxBadges() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.blackBox}"
          "${ApiGameBadges.blackBoxBadges}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch black box badges: $e");
    }
  }

  /// ✅ Fetch One Word Badges
  Future<BadgeResponse> getOneWordBadges() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.oneWord}"
          "${ApiGameBadges.oneWordBadges}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch one word badges: $e");
    }
  }
}
