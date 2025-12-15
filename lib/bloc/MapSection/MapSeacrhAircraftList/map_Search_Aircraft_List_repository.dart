import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'map_Search_Aircraft_List_Model.dart';

class MapSearchAircraftListRepository {
  Future<MapSearchAircraftListModel> getListOfAllLiveFlights({
    required String querySearch,
  }) async {
    final url = Uri.parse(
      "${MapFlightAircraftSectionConstant.baseUrlSearch}$querySearch&limit=10&type=live",
    );
    try {
      final jsonData = await ApiService.get(url: url) as Map<String, dynamic>;
      return MapSearchAircraftListModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
