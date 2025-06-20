import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
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
      final response = await ApiService.get(url: uri);
      final Map<String, dynamic> jsonData = response;

      final List<dynamic> dataList = jsonData['data'];
      return dataList.map((item) => Manufacturer.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch manufacturers: $e');
    }
  }
}
