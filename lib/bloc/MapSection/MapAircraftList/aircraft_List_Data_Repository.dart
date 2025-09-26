import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import 'aircraft_List_Data_State.dart';

class AircraftListDataRepository {
  // Existing method
  Future<AircraftListResponse> getListOfAllPlanes({
    required List<String> aircraftIds,
  }) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiFunctionUrlMapSecitonConstant.aircraftFlyingList}",
    );

    try {
      final jsonData =
          await ApiService.post(url: url, body: {"aircraft_id": aircraftIds})
              as Map<String, dynamic>;
      return AircraftListResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
