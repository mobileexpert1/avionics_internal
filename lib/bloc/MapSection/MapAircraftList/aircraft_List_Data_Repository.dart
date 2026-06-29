import 'dart:ui';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'aircraft_List_Data_State.dart';

class AircraftListDataRepository {
  Future<AircraftListResponse> getListOfAllPlanes({
    required List<String> aircraftIds,
    required List<String> callSignListTypes,
  }) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiFunctionUrlMapSectionConstant.aircraftFlyingList}",
    );

    try {
      final body = {"aircraft_id": aircraftIds, "callSign": callSignListTypes};
      final jsonData =
          await ApiService.post(
                url: url,
                body: body,
              )
              as Map<String, dynamic>;
      return AircraftListResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AircraftListResponse> searchAircraftByICAO(
    String icaoCode,
  ) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "aircraft/icao-aircraft/$icaoCode",
    );

    try {
      final jsonResponse =
          await ApiService.get(url: url)
              as Map<String, dynamic>;
      return AircraftListResponse.fromJson(jsonResponse);
    } catch (e) {
      throw e.toString();
    }
  }
}
