import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../Database/db_helper.dart';
import 'manufacturer_model.dart';

class ManufacturerRepository {
  Future<List<Manufacturer>> getManufacturers({String? query}) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getManufacturer +
          (query != null && query.isNotEmpty ? '?q=$query' : ''),
    );

    try {
         final Map<String, dynamic> jsonData =
      await ApiService.get(url: uri) as Map<String, dynamic>;

      final List<dynamic> dataList = jsonData['data'] ?? [];
      final manufacturers = dataList
          .map((item) => Manufacturer.fromJson(item))
          .toList();
      await DBHelper.insertManufacturers(manufacturers);
      return manufacturers;
    } catch (e) {
      final cached = await DBHelper.getManufacturersFromDb();
      if (cached.isNotEmpty) {
        return cached
            .map((row) => Manufacturer(
          id: row.id,
          companyName: row.companyName,
          icon: row.icon,
        ))
            .toList();
      }
      throw Exception('Failed to fetch manufacturers: $e');
    }

  }
}
