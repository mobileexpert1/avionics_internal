import 'dart:convert';

import 'package:avionics_internal/Database/generic_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../MapSection/flight_key_values_model.dart';
import '../../MapSection/flight_map_repository.dart';
import '../../home/manufacturer/manufacturer_list_model.dart';
import 'home_model.dart';

class HomeRepository {
  HomeRepository()
    : _manufacturers = GenericMethods<ManufacturerListModel>(
        ManufacturerListModel.fromMap,
      );

  final GenericMethods<ManufacturerListModel> _manufacturers;

  Future<FlightKeyValuesModel?> getMapKeyValueFromServer() async {
    bool? apiTokenSever = await SharedPrefsHelper.getApiFetchKeyFromSever();
    if (apiTokenSever == null || apiTokenSever == false) {
      final uri = Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.authFetchGoogleKey,
      );
      try {
        final jsonData =
            await ApiService.get(url: uri, isForFlightRadar: true)
                as Map<String, dynamic>;
        final modelResponse = FlightKeyValuesModel.fromJson(jsonData);
        if (!kIsWeb) {
          await const MethodChannel('com.app/google_maps').invokeMethod(
            "googleMapsKey",
            {"key": modelResponse.data.googleMapsKey},
          );
        }
        await SharedPrefsHelper.saveApiFetchKeyFromSever(true);
        return modelResponse;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
    return null;
  }

  Future<void> getFlightKeyValueFromServer() async {
    final localKey = await SharedPrefsHelper.getMapKeyValuesForApi();
    if (localKey.isNotEmpty) {
      return;
    }
    try {
      final response = await FlightRepository().getMapKeyValueFromServer(
      );
      if (response.data.fr24 != null && response.data.fr24!.isNotEmpty) {
        await SharedPrefsHelper.seMapKeyValuesFromServer(response.data.fr24!);
      }
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<HomeResponse> getHomeData() async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getExploreData,
    );
    try {
      final response = await ApiService.get(url: uri);
      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;
      final homeData = HomeResponse.fromJson(json);
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
    return HomeResponse(
      detail: '',
      isActiveSubscription: false,
      manufacturers: manufacturers,
      favourites: [],
      flights: const [],
      currentPlan: null,
    );
  }
}
