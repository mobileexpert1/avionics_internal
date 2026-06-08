import 'dart:ui';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'savedFlight_model.dart';

class SavedFlightRepository {
  Future<SavedFlightResponse> getSavedAndFavoriteAircraft(
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiServiceUrlAirplaneConstant.getListAirbus}save-favorite",
    );

    try {
      final jsonData =
          await ApiService.get(url: uri)
              as Map<String, dynamic>;
      return SavedFlightResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Set<String>> getFavoriteCallSigns() async {
    final response = await getSavedAndFavoriteAircraft();
    return response.favorite.map((e) => e.callsign).whereType<String>().toSet();
  }
}
