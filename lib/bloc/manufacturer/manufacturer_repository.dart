import 'package:avionics_internal/Database/generic_methods.dart';
import 'package:avionics_internal/bloc/manufacturer/manufacturer_list_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'Manufacturer_detail_model.dart';

class ManufacturerRepository {
  ManufacturerRepository()
      : _manufacturer = GenericMethods<ManufacturerListModel>(ManufacturerListModel.fromMap);
  final GenericMethods<ManufacturerListModel> _manufacturer;

  Future<List<ManufacturerListModel>> getListOfManufacturers({String? query}) async {
    if (!await GenericMethods.hasInternet()) {
      return _getLocalData();
    }
    final uri = Uri.parse(ApiBaseUrlConstant.baseUrl +
        ApiFunctionUrlAirplaneConstant.airplaneService +
        ApiServiceUrlAirplaneConstant.getListManufacturer +
        (query != null && query.isNotEmpty ? '?q=$query' : ''),);
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final manufacturers = (jsonData['data'] as List<dynamic>? ?? []).map((
          e) => ManufacturerListModel.fromJson(e)).toList();
      await _manufacturer.insertAll(manufacturers);
      return manufacturers;
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ManufacturerListModel>> _getLocalData() async {
    return _manufacturer.getAll('manufacturers');
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
      return ManufacturerDetailResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }

}