import 'dart:developer' as dev;
import 'package:avionics_internal/Database/generic_methods.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'manufacturer_model.dart';

class ManufacturerRepository {

  ManufacturerRepository() : _repository = GenericMethods<Manufacturer>(Manufacturer.fromMap);
  final GenericMethods<Manufacturer> _repository;

  Future<List<Manufacturer>> getManufacturers({String? query}) async {
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

      await _repository.insertAll(manufacturers);

      return manufacturers;
    } catch (e) {
      dev.log('Network failed → fall back to cache', error: e, name: 'repo');

      final cached = await _repository.getAll('manufacturers');
      if (cached.isNotEmpty) return cached;

      throw Exception('No manufacturers in cache and network call failed.');
    }

  }
}
