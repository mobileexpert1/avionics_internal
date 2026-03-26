import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'gameBadges_model.dart';

class BadgesRepository {
  // Fetch Quiz Badges (Local Mock Data)
  Future<BadgeResponse> getQuizBadges() async {
    try {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
        "${ApiFunctionUrlGamesConstant.quiz}"
        "${ApiGameBadges.quizBadges}/",
      );

      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  // Fetch One Word Badges
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
      throw e.toString();
    }
  }

  // Fetch Black Box Badges
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
      throw e.toString();
    }
  }

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
      throw e.toString();
    }
  }
}
