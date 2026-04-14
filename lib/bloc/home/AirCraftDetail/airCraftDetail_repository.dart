import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';
import 'airCraftDetail_model.dart';

class AirCraftRepository {
  Future<AirCraftDetailResponse> getAirCraftData(
    String airCraftId, {
    VoidCallback? onUnauthorized,
  }) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiFunctionUrlAirplaneConstant.airCraftDetail +
          airCraftId,
    );
    try {
      final response = await ApiService.get(
        url: uri,
        onUnauthorized: onUnauthorized,
      );

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
      String ICAOCode, {
        VoidCallback? onUnauthorized,
      }) async {
    final uri = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiFunctionUrlAirplaneConstant.airCraftDetailICAOCode +
          ICAOCode,
    );
    try {
      final response = await ApiService.get(
        url: uri,
        onUnauthorized: onUnauthorized,
      );

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
}
