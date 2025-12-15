import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/Custom_Pagination.dart';
import '../../../Database/generic_methods.dart';
import 'AircraftComparisonModel.dart';

class AircraftRepository {
  Future<PaginatedList<AircraftModel>> getCompareList({
    String? query,
    int page = 1,
  }) async {
    // Not working in Web section
    // if (!await GenericMethods.hasInternet()) {
    //   return PaginatedList<AircraftModel>(
    //     results: [],
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
      "?page=$page"
      "${query != null && query.isNotEmpty ? '&q=$query' : ''}&max_page_size=10",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return PaginatedList.fromJson(
        json: jsonData,
        fromJson: (e) => AircraftModel.fromJson(e),
        currentPage: page,
      );
    } catch (e, st) {
      throw e.toString();
    }
  }
}
