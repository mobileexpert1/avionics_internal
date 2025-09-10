import 'dart:convert';
import 'dart:ui';
import 'package:avionics_internal/Database/generic_methods.dart';
import 'package:flutter/foundation.dart';
import '../manufacturer/manufacturer_list_model.dart';
import 'home_model.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';

class HomeRepository {
  HomeRepository()
      : _manufacturers = GenericMethods<ManufacturerListModel>(ManufacturerListModel.fromMap);

  final GenericMethods<ManufacturerListModel> _manufacturers;

  Future<HomeResponse> getHomeData({VoidCallback? onUnauthorized}) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getExploreData,
    );
    try {
      final response = await ApiService.get(
        url: uri,
        onUnauthorized: onUnauthorized,
      );
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;
      final homeData = HomeResponse.fromJson(json);

      await _manufacturers.insertAll(homeData.manufacturers);
     // await _favorites.insertAll(homeData.favourites);

      return homeData;
    } on HttpStatusException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return _getLocalData();
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<HomeResponse> _getLocalData() async {
    final manufacturers = await _manufacturers.getAll('manufacturers');
    //final favourites = await _favorites.getAll('favourites');

    return HomeResponse(
      detail: '',
      isActiveSubscription: false,
      manufacturers: manufacturers,
      favourites: [],
      flights: const [],
    );
  }
}

