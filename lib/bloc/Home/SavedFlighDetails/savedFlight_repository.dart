import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'savedFlight_model.dart';

class SavedFlightRepository {
  Future<SavedFlightResponse> getSavedAndFavoriteAircrafts() async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlAirplaneConstant.airplaneService}"
          "${ApiServiceUrlAirplaneConstant.getListAirbus}save-favorite",

    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return SavedFlightResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to fetch saved/favorite aircrafts: $e");
    }
  }
}
