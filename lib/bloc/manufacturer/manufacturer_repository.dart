import 'package:avionics_internal/Database/generic_methods.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'manufacturer_model.dart';

class ManufacturerRepository {
  ManufacturerRepository()
    : _manufacturer = GenericMethods<Manufacturer>(Manufacturer.fromMap);
  final GenericMethods<Manufacturer> _manufacturer;

  Future<List<Manufacturer>> getManufacturers({String? query}) async {
    if (!await GenericMethods.hasInternet()) {
      return _getLocalData();
    }
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getManufacturer +
          (query != null && query.isNotEmpty ? '?q=$query' : ''),
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final manufacturers = (jsonData['data'] as List<dynamic>? ?? [])
          .map((e) => Manufacturer.fromJson(e))
          .toList();

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

  Future<List<Manufacturer>> _getLocalData() async {
    return _manufacturer.getAll('manufacturers');
  }
}
