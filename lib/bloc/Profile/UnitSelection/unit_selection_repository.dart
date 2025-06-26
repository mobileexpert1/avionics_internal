import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/UnitSelection/unit_selection_model.dart';
import '../../../Constants/ApiClass/api_service.dart';
import '../../../Constants/ConstantStrings.dart';

class UnitSelectionRepository {
  Future<UnitSelectionModel> getUnitPreferences({required String token}) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlConstant.userService +
          ApiServiceUrlConstant.getUnitselection,
    );

    try {
      final response = await ApiService.get(
        url: url,
        headers: {"Authorization": "Bearer $token"},
      );
      return UnitSelectionModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UnitSelectionModel> updateUnitPreferences({
    required String token,
    required String speed,
    required String altitude,
    required String distance,
    required String temperature,
  }) async {
    final body = {
      "speed": speed,
      "altitude": altitude,
      "distance": distance,
      "temperature": temperature,
    };

    final response = await ApiService.put(
      url: Uri.parse(
        ApiBaseUrlConstant.baseUrl +
            ApiFunctionUrlConstant.userService +
            ApiServiceUrlConstant.updateUnitselection,
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body:body,
    );

    return UnitSelectionModel.fromJson(response);
  }

}
