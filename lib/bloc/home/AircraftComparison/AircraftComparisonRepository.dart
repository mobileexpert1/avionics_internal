import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/Custom_Pagination.dart';
import 'AircraftComparisonModel.dart';

class AircraftRepository {
  Future<PaginatedList<AircraftModel>> getCompareList({
    String? query,
    int page = 1,
  }) async {
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
    } catch (e) {
      throw e.toString();
    }
  }
}
