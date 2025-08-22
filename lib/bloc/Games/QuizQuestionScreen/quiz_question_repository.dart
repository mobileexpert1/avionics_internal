import 'package:flutter/cupertino.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';
import '../SubGameSection/Calculation_Section/calculation_submit_model.dart';
import 'QuestionResult.dart';

class QuizQuestionRepository {
  // Mapping of game numbers to game names
  static const Map<int, String> gameNoAssign = {
    1: "take_measure",
    2: "flight_math",
    3: "gree_new_blue",
    4: "mind_separation",
  };

  /// Fetch calculation game data from API for a specific game number
  Future<CalculationGameModel?> getCalculationData(int gameNumber,int actionNumber) async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

    // Validate gameNumber
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number: $gameNumber";
    }

    final gameName = gameNoAssign[gameNumber];
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.calculationQuestions}"
      "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber,actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw "Failed to fetch data for $gameName: $e";
    }
  }

  Future<CalculationGameModel?> fetchAdditionalQuestions(int gameNumber, int actionNumber) async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

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
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      debugPrint("Background fetch failed for action $actionNumber: $e");
      return null;
    }
  }
  // /// Submit calculation result to API
  // Future<SubmitCalculationResultResponse> submitCalculationResult(
  //   Map<String, dynamic> payload,
  // ) async {
  //   if (!await GenericMethods.hasInternet()) {
  //     throw "No internet connection";
  //   }
  //
  //   // Extract gameNumber from payload or default to 1
  //   final gameNumber = payload['game_number'] ?? 1;
  //   if (!gameNoAssign.containsKey(gameNumber)) {
  //     throw "Invalid game number in payload: $gameNumber";
  //   }
  //
  //   final uri = Uri.parse(
  //     "${ApiBaseUrlConstant.baseUrl}"
  //     "${ApiFunctionUrlGamesConstant.calculationSubmit}"
  //     "${ApiServiceUrlGamesConstant.submitCalculationResults(gameNumber)}",
  //   );
  //
  //   try {
  //     final response = await ApiService.post(url: uri, body: payload);
  //     return SubmitCalculationResultResponse.fromJson(response);
  //   } catch (e) {
  //     throw "Failed to submit result for game $gameNumber: $e";
  //   }
  // }


  ///One word API

  Future<CalculationGameModel?> getOneWordData(int gameNumber,int actionNumber) async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

    // Validate gameNumber
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number: $gameNumber";
    }

    final gameName = gameNoAssign[gameNumber];
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.oneWordQuestions}"
          "${ApiServiceUrlGamesConstant.getLimitedQuestions(gameNumber,actionNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw "Failed to fetch data for $gameName: $e";
    }
  }


  Future<CalculationGameModel?> fetchOneWordQuestions(int gameNumber, int actionNumber) async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

    // Validate gameNumber
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number: $gameNumber";
    }

    final gameName = gameNoAssign[gameNumber];
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.oneWordQuestions}"
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



  // Future<SubmitCalculationResultResponse> submitOneWordResult(
  //     Map<String, dynamic> payload,
  //     ) async {
  //   if (!await GenericMethods.hasInternet()) {
  //     throw "No internet connection";
  //   }
  //
  //   // Extract gameNumber from payload or default to 1
  //   final gameNumber = payload['game_number'] ?? 1;
  //   if (!gameNoAssign.containsKey(gameNumber)) {
  //     throw "Invalid game number in payload: $gameNumber";
  //   }
  //
  //   final uri = Uri.parse(
  //     "${ApiBaseUrlConstant.baseUrl}"
  //         "${ApiFunctionUrlGamesConstant.oneWordSubmit}"
  //         "${ApiServiceUrlGamesConstant.submitOneWordResults(gameNumber)}",
  //   );
  //
  //   try {
  //     final response = await ApiService.post(url: uri, body: payload);
  //     return SubmitCalculationResultResponse.fromJson(response);
  //   } catch (e) {
  //     throw "Failed to submit result for game $gameNumber: $e";
  //   }
  // }


  Future<SubmitCalculationResultResponse> submitResult(
      Map<String, dynamic> payload,
      String gameId,
      ) async {
    if (!await GenericMethods.hasInternet()) {
      throw "No internet connection";
    }

    final gameNumber = payload['game_number'] ?? 1;
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number in payload: $gameNumber";
    }

    // Select the appropriate submit URL based on gameId
    String submitUrl;
    if (gameId == "calculation") {
      submitUrl = "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitCalculationResults(gameNumber)}";
    } else if (gameId == "one_word") {
      submitUrl = "${ApiBaseUrlConstant.baseUrl}${ApiServiceUrlGamesConstant.submitOneWordResults(gameNumber)}";
    } else {
      throw Exception('Invalid gameId: $gameId');
    }

    final uri = Uri.parse(submitUrl);

    try {
      final response = await ApiService.post(url: uri, body: payload);
      print('Submit response for $gameId game $gameNumber: ${response.data}');
      return SubmitCalculationResultResponse.fromJson(response);
    } catch (e) {
      print('Failed to submit result for $gameId game $gameNumber: $e');
      throw "Failed to submit result for $gameId game $gameNumber: $e";
    }
  }
}
