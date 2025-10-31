import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'conversion_model.dart';

class ConversionRepository {
  Future<List<ConversionCategory>> getAllConversions() async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlAirplaneConstant.airplaneService}"
          "conversions",
    );

    try {
      final jsonData = await ApiService.get(url: url) as List<dynamic>;

      return jsonData.map((item) => ConversionCategory.fromJson(item)).toList();
    } catch (e) {
      throw Exception("Failed to fetch conversions: $e");
    }
  }
}
