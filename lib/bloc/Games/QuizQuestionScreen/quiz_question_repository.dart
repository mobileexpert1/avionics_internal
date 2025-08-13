import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Database/generic_methods.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';

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

/// Submit calculation results to API
// Future<bool> submitCalculationResults(CalculationGameModel model) async {
//   if (!await GenericMethods.hasInternet()) {
//     return false;
//   }
//
//   final uri = Uri.parse(
//     "${ApiBaseUrlConstant.baseUrl}"
//         "${ApiFunctionUrlGamesConstant.calculationService}"
//         "${ApiServiceUrlGamesConstant.submitCalculationResults}",
//   );
//
//   try {
//     final body = jsonEncode(model.toJson());
//     await ApiService.post(url: uri, body: body);
//     return true;
//   } catch (e) {
//     throw e.toString();
//   }
// }
}
