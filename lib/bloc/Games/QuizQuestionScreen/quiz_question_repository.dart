import 'package:flutter/cupertino.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import '../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';
import '../SubGameSection/Calculation_Section/calculation_submit_model.dart';

class QuizQuestionRepository {
  Future<BaseDetailResponseModel> reportQuestionPostMethod({
    required String setId,
    required String questionId,
    required String reason,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlGamesConstant.quiz +
          ApiFunctionUrlGamesConstant.reportQuestion,
    );
    try {
      final response = await ApiService.post(
        url: url,
        body: {"set_id": setId, "reason": reason, "question_id": ""},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  // Mapping of game numbers to game names
  static const Map<int, String> gameNoAssign = {
    1: "take_measure",
    2: "flight_math",
    3: "gree_new_blue",
    4: "mind_separation",
  };

  /// Fetch calculation game data from API for a specific game number
  Future<CalculationGameModel?> getCalculationData(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }

    // Validate gameNumber
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number: $gameNumber";
    }

    final gameName = gameNoAssign[gameNumber];
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.calculationQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw "Failed to fetch data for $gameName: $e";
    }
  }

  Future<CalculationGameModel?> fetchAdditionalQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }

    // Validate gameNumber
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number: $gameNumber";
    }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.calculationQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Response JsonData =:$jsonData $actionNumber");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      debugPrint("Background fetch failed for action $actionNumber: $e");
      return null;
    }
  }

  ///One word Get API
  Future<CalculationGameModel?> getOneWordData(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.oneWordQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  ///One word Get Questions API
  Future<CalculationGameModel?> fetchOneWordQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.oneWordQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  ///Quiz Get Questions API
  Future<CalculationGameModel?> getQuizData(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.quizQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  ///Quiz Get Questions API hit background
  Future<CalculationGameModel?> fetchQuizQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.quizQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber, actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SubmitCalculationResultResponse> submitResult(
    Map<String, dynamic> payload,
    String gameId,
  ) async {
    // Not Working in Web Section
    // if (!await GenericMethods.hasInternet()) {
    //   return null;
    // }

    final gameNumber = payload['game_number'] ?? 1;
    // if (!gameNoAssign.containsKey(gameNumber)) {
    //   throw "Invalid game number in payload: $gameNumber";
    // }
    // Select the appropriate submit URL based on gameId
    String submitUrl;
    if (gameId == "calculation") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitCalculationResults(gameNumber)}";
    } else if (gameId == "one_word") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitOneWordResults(gameNumber)}";
    } else if (gameId == "quiz") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitQuizResults(gameNumber)}";
    } else {
      throw Exception('Invalid gameId: $gameId');
    }

    final uri = Uri.parse(submitUrl);

    try {
      final response = await ApiService.post(url: uri, body: payload);
      // Treat response as a Map<String, dynamic>
      print(
        'Submit response for $gameId game $gameNumber: ${response['data']}',
      );
      return SubmitCalculationResultResponse.fromJson(response);
    } catch (e) {
      print('Failed to submit result for $gameId game $gameNumber: $e');
      throw e.toString();
    }
  }
}
