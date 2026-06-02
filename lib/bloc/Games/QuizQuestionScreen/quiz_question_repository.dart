import 'package:flutter/cupertino.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';
import '../SubGameSection/Calculation_Section/calculation_submit_model.dart';

class QuizQuestionRepository {
  Future<BaseDetailResponseModel> reportQuestionPostMethod({
    required String setId,
    required String questionId,
    required String reason,
    required String isForType,
  }) async {
    Uri? url;
    switch (isForType) {
      case "quiz":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.quiz +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
        break;
      case "one_word":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.oneWord +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
      case "calculation":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.calculation +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
        break;
      case "black_box":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.blackBoxTopic +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
        break;
      case "trivia":
        url = Uri.parse(
          "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlGamesConstant.trivia}${ApiFunctionUrlGamesConstant.reportQuestion}",
        );
        break;
      case "imageBased":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.imageBased +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
        break;
      case "aircraftEncyclopaedia":
        url = Uri.parse(
          ApiBaseUrlConstant.baseUrl +
              ApiFunctionUrlGamesConstant.encyclopaedia +
              ApiFunctionUrlGamesConstant.reportQuestion,
        );
        break;
      default:
        url = null;
    }

    try {
      final response = await ApiService.post(
        url: url!,
        body: {"set_id": setId, "reason": reason, "question_id": questionId},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  static const Map<int, String> gameNoAssign = {
    1: "take_measure",
    2: "flight_math",
    3: "gree_new_blue",
    4: "mind_separation",
  };

  Future<CalculationGameModel?> getCalculationData(
    int gameNumber,
    int actionNumber,
  ) async {
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
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw "Failed to fetch data for $gameName: $e";
    }
  }

  Future<CalculationGameModel?> fetchAdditionalQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
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
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      debugPrint("Background fetch failed for action $actionNumber: $e");
      return null;
    }
  }

  Future<CalculationGameModel?> getOneWordData(
    int gameNumber,
    int actionNumber,
  ) async {
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

  Future<CalculationGameModel?> fetchOneWordQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
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

  Future<CalculationGameModel?> getQuizData(
    int gameNumber,
    int actionNumber,
  ) async {
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

  Future<CalculationGameModel?> getTriviaData(
    int gameNumber,
    int actionNumber,
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.triviaTopic}",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      if (jsonData['empty'] == true) {
        return null;
      }
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CalculationGameModel?> getImageBasedQuestionData(
    int actionNumber,
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.imageBasedTopic}",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CalculationGameModel?> getAircraftEncyclopaediaQuestionData(
    int actionNumber,
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.encyclopaediaTopics}",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<CalculationGameModel?> fetchQuizQuestions(
    int gameNumber,
    int actionNumber,
  ) async {
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
    final gameNumber = payload['game_number'] ?? 1;
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
    } else if (gameId == "imageBased") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitImageBasedResults}";
    } else if (gameId == "trivia") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitTriviaResults}";
    } else if (gameId == "aircraftEncyclopaedia") {
      submitUrl =
          "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.encyclopaediaResults}";
    } else {
      throw Exception('Invalid gameId: $gameId');
    }

    final uri = Uri.parse(submitUrl);

    try {
      final response = await ApiService.post(url: uri, body: payload);
      return SubmitCalculationResultResponse.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}