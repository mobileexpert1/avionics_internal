import 'dart:convert';

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

  /// ✅ Fetch Quiz Badges (Local Mock Data)
  Future<BadgeResponse> getQuizBadges({
    required int userWins,
    required int totalPoints,
  }) async {
    try {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
        "${ApiFunctionUrlGamesConstant.quiz}"
        "${ApiGameBadges.quizBadges}/",
      );

      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return BadgeResponse.fromJson(jsonData);
      //   // Simulate network delay
      //   await Future.delayed(const Duration(milliseconds: 800));
      //
      //   // ✅ Local mock data
      //   const jsonString = '''
      // {
      //   "detail": "Quiz badges fetch successfully",
      //   "total_earn_point": 0,
      //   "data": [
      //     {
      //       "id": "138157f5-3821-4d52-8d59-c5fd110956f9",
      //       "name": "Cloud Chaser",
      //       "wins": 2,
      //       "icon": "https://avionica.csdevhub.com/s3/manufacturer/Group%201686560173%20(2).svg",
      //       "is_earned": false,
      //       "require_win": 2,
      //       "total_win": 0
      //     },
      //     {
      //       "id": "24e2adbc-d091-48e1-b8f8-be171e1bb1b7",
      //       "name": "Noctilucent Explorer",
      //       "wins": 2,
      //       "icon": "https://avionica.csdevhub.com/s3/manufacturer/Group%201686560175%20(1).png",
      //       "is_earned": false,
      //       "require_win": 2,
      //       "total_win": 0
      //     },
      //     {
      //       "id": "9e0599f2-b1a5-4d91-ac3e-def2a19e88e8",
      //       "name": "Space Shuttle",
      //       "wins": 2,
      //       "icon": "https://avionica.csdevhub.com/s3/manufacturer/Group%201686560177.png",
      //       "is_earned": false,
      //       "require_win": 2,
      //       "total_win": 0
      //     },
      //     {
      //       "id": "a2368f61-184d-478e-a636-653a050fe720",
      //       "name": "Jetstream Voyager",
      //       "wins": 2,
      //       "icon": "https://avionica.csdevhub.com/s3/manufacturer/Group%201686560174%20(1).png",
      //       "is_earned": false,
      //       "require_win": 2,
      //       "total_win": 0
      //     },
      //     {
      //       "id": "a71d58fa-a715-4e37-94ab-359d018e291a",
      //       "name": "Aurora Sentinel",
      //       "wins": 2,
      //       "icon": "https://avionica.csdevhub.com/s3/manufacturer/Group%201686560176%20(1).png",
      //       "is_earned": false,
      //       "require_win": 2,
      //       "total_win": 0
      //     }
      //   ]
      // }
      // ''';
      //
      //   // ✅ Decode and return as BadgeResponse
      //   final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      //   return BadgeResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch quiz badges (local): $e");
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
