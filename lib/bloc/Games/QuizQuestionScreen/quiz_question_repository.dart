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
  Future<CalculationGameModel?> getCalculationData(int gameNumber) async {
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
      "${ApiFunctionUrlGamesConstant.calculationService}"
      "${ApiServiceUrlGamesConstant.getQuestions(gameNumber)}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      print("Fetched Data From Server$jsonData");
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw "Failed to fetch data for $gameName: $e";
    }
  }

  /// Submit calculation result to API
  Future<SubmitCalculationResultResponse> submitCalculationResult(
    Map<String, dynamic> payload,
  ) async {
    if (!await GenericMethods.hasInternet()) {
      throw "No internet connection";
    }

    // Extract gameNumber from payload or default to 1
    final gameNumber = payload['game_number'] ?? 1;
    if (!gameNoAssign.containsKey(gameNumber)) {
      throw "Invalid game number in payload: $gameNumber";
    }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlGamesConstant.calculationService}"
      "${ApiServiceUrlGamesConstant.submitCalculationResults(gameNumber)}",
    );

    try {
      final response = await ApiService.post(url: uri, body: payload);
      return SubmitCalculationResultResponse.fromJson(response);
    } catch (e) {
      throw "Failed to submit result for game $gameNumber: $e";
    }
  }
}
