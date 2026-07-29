import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'FlightInfoParamsResponse.dart';
import 'airCraftDetail_model.dart';

class AirCraftRepository {
  Future<AirCraftDetailResponse> getAirCraftData(String airCraftId) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiFunctionUrlAirplaneConstant.aircraftDetail +
          airCraftId,
    );
    try {
      final response = await ApiService.get(url: uri);

      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      final aircraft = AirCraftDetailResponse.fromJson(json);
      debugPrint("Parsed Successfully");
      return aircraft;
    } on HttpStatusException catch (e, stacktrace) {
      debugPrint("Parsing error: $e");
      debugPrint("Stacktrace: $stacktrace");
      if (e.statusCode == 400 || e.statusCode == 404) {}
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AirCraftDetailResponse> getAirCraftDetailICAOCode(
    String ICAOCode,
  ) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiFunctionUrlAirplaneConstant.aircraftDetailIcaoCode +
          ICAOCode,
    );
    try {
      final response = await ApiService.get(url: uri);

      final Map<String, dynamic> json = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;

      final aircraft = AirCraftDetailResponse.fromJson(json);
      debugPrint("Parsed Successfully");
      return aircraft;
    } on HttpStatusException catch (e, stacktrace) {
      debugPrint("Parsing error: $e");
      debugPrint("Stacktrace: $stacktrace");
      if (e.statusCode == 400 || e.statusCode == 404) {}
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<FlightInfoParamsResponse?> getTheFlightInfoParamsResponse(
    int actionNumber,
  ) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
      "${ApiFunctionUrlAirplaneConstant.airplaneService}"
      "${ApiServiceUrlAirplaneConstant.getListAirbus}"
      "${ApiFunctionUrlAirplaneConstant.paramInfo}"
      "$actionNumber",
    );
    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;
      return FlightInfoParamsResponse.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}
