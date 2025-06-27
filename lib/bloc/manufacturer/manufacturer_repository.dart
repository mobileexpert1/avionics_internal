import 'dart:developer' as dev;
import 'package:avionics_internal/Constants/ApiClass/baseDetailResponseModel.dart';
import 'package:avionics_internal/Database/generic_methods.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'Manufacturer_detail_model.dart';
import 'manufacturer_list_model.dart';

class ManufacturerRepository {
  ManufacturerRepository()
    : _repository = GenericMethods<ManufacturerListModel>(
        ManufacturerListModel.fromMap,
      );
  final GenericMethods<ManufacturerListModel> _repository;

  Future<List<ManufacturerListModel>> getListOfManufacturers({
    String? query,
  }) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getListManufacturer +
          (query != null && query.isNotEmpty ? '?q=$query' : ''),
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      final manufacturers = (jsonData['data'] as List<dynamic>? ?? [])
          .map((e) => ManufacturerListModel.fromJson(e))
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
