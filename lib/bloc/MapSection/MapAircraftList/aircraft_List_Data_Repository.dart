import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Database/generic_methods.dart';
import '../../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'aircraft_List_Data_State.dart';

class AircraftListDataRepository {
  Future<AircraftListResponse> getListOfAllPlanes({
    required List<String> aircraftIds,
  }) async {
    if (!await GenericMethods.hasInternet()) {
      return AircraftListResponse(
        detail: "No internet",
        data: await _getLocalData(),
      );
    }

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

  Future<List<AircraftModel>> _getLocalData() async {
    return [];
  }
}
