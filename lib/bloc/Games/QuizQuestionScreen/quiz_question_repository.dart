import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';
import '../SubGameSection/Calculation_Section/calculation_submit_model.dart';
import 'QuestionResult.dart';

class QuizQuestionRepository {
  /// Fetch calculation game data from API
  Future<CalculationGameModel?> getCalculationData() async {
    if (!await GenericMethods.hasInternet()) {
      return null;
    }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.calculationService}"
          "${ApiServiceUrlGamesConstant.takeMeasureCalculation}",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return CalculationGameModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<SubmitCalculationResultResponse> submitCalculationResult(
      Map<String, dynamic> payload) async {
    if (!await GenericMethods.hasInternet()) {
      throw "No internet connection";
    }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlGamesConstant.calculationService}"
          "${ApiServiceUrlGamesConstant.submitCalculationResults}",
    );

    try {
      final response = await ApiService.post(url: uri, body: payload);
      return SubmitCalculationResultResponse.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }



}

