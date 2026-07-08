import 'package:avionics_internal/bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class AircraftStationListRepository {
  Future<AircraftStationListResponse>
  getListOfAllAircraftStationAccordingToLatLong({
    required String longitude,
    required String latitude,
  }) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiFunctionUrlMapSectionConstant.aircraftListNew}",
    ).replace(queryParameters: {'longitude': longitude, 'latitude': latitude});

    try {
      final jsonData =
          await ApiService.get(url: url)
              as Map<String, dynamic>;
      return AircraftStationListResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
