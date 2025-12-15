import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'formula_model.dart';

class FormulaRepository {
  Future<List<FormulaModel>> getAllFormulas() async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlAirplaneConstant.airplaneService}"
          "formulas",
    );

    try {
      final jsonData = await ApiService.get(url: url) as List<dynamic>;

      return jsonData.map((item) => FormulaModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Failed to fetch formulas: $e");
    }
  }
}
