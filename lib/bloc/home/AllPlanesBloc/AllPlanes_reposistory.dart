import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_model.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/Custom_Pagination.dart';

class AllPlanesReposistory {
  Future<PaginatedList<AircraftListModel>> getListOfAllPlanes({
    String? query,
    int page = 1,
    required String selectedAirbusId,
  }) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiServiceUrlAirplaneConstant.getListAirbus}"
      "$selectedAirbusId"
      "?page=$page"
      "${query != null && query.isNotEmpty ? '&q=$query' : ''}&max_page_size=10",
    );

    try {
      final jsonData =
          await ApiService.get(url: uri)
              as Map<String, dynamic>;
      final paginated = PaginatedList.fromJson(
        json: jsonData,
        fromJson: (e) => AircraftListModel.fromJson(e),
        currentPage: page,
      );
      return paginated;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> setFavOrUnfavPlanFromList({required String aircraftId,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.saveUnSavePlane,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {"aircraft_id": aircraftId},
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> setFavOrUnfavPlanFromList1({
    required String aircraftId,
    required String callSign,
    required String flightId,
    required String flightNumber,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.favUnFavPlane,
    );

    try {
      final response = await ApiService.post(
        url: url,
        body: {
          "aircraft_id": aircraftId,
          "callsign": callSign,
          "flight_id": flightId,
          "flight_number": flightNumber,
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
