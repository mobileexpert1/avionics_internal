import 'package:avionics_internal/Database/generic_methods.dart';
import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/Custom_Pagination.dart';

class AllPlanesReposistory {
  AllPlanesReposistory()
    : _manufacturer = GenericMethods<AircraftListModel>(
        AircraftListModel.fromMap,
      );
  final GenericMethods<AircraftListModel> _manufacturer;

  Future<PaginatedList<AircraftListModel>> getListOfAllPlanes({
    String? query,
    int page = 1,
    required String selectedAirbusId,
  }) async {
    // Not Working in web section
    // if (!await GenericMethods.hasInternet()) {
    //   return PaginatedList<AircraftListModel>(
    //     results: await _getLocalData(),
    //     count: 0,
    //     totalPages: 1,
    //     currentPage: 1,
    //     hasNext: false,
    //     hasPrevious: false,
    //   );
    // }

    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlAirplaneConstant.airplaneService}"
          "${ApiServiceUrlAirplaneConstant.getListAirbus}"
          "$selectedAirbusId"
          "?page=$page"
          "${query != null && query.isNotEmpty ? '&q=$query' : ''}&max_page_size=10",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
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

  Future<List<AircraftListModel>> _getLocalData() async {
    return _manufacturer.getAll('allAircraftsList');
  }

  Future<BaseDetailResponseModel> setFavOrUnfavPlanFromList({
    required String aircraftId,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.savUnSAvePlane,
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
          "flight_number":flightNumber
        },
      );
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }
}
