import 'package:avionics_internal/Database/generic_methods.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/Custom_Pagination.dart';
import 'Manufacturer_detail_model.dart';
import 'manufacturer_list_model.dart';

class ManufacturerRepository {
  ManufacturerRepository()
    : _manufacturer = GenericMethods<ManufacturerListModel>(
        ManufacturerListModel.fromMap,
      );
  final GenericMethods<ManufacturerListModel> _manufacturer;

  Future<PaginatedList<ManufacturerListModel>> getListOfManufacturers({
    String? query,
    int page = 1,
    bool helicopter = false,
    bool airplane = false,
  }) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiServiceUrlAirplaneConstant.getListManufacturer}"
      "?page=$page"
      "${query != null && query.isNotEmpty ? '&q=$query' : ''}"
      "&helicopter=$helicopter"
      "&airplane=$airplane",
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final paginated = PaginatedList.fromJson(
        json: jsonData,
        fromJson: (e) => ManufacturerListModel.fromJson(e),
        currentPage: page,
      );

      if (page == 1) {
        await _manufacturer.insertAll(paginated.results);
      }

      return paginated;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ManufacturerDetailResponse> getParticularAirbusDetail({
    required String query,
  }) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getListManufacturer +
          (query.isNotEmpty ? query : ''),
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      print(jsonData);
      return ManufacturerDetailResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
