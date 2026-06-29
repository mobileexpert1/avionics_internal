import 'dart:ui';

import 'package:avionics_internal/bloc/Home/AircraftComparison/Comparison/ComparisonModel.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ConstantStrings.dart';

class ComparisonRepository {
  Future<ComparisonModel> compareAircrafts({
    required String aircraft1Id,
    required String aircraft2Id,
  }) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlAirplaneConstant.airplaneService}"
          "${ApiServiceUrlAirplaneConstant.compareAircraft}",
    );

    final body = {
      "aircraft_id_1": aircraft1Id,
      "aircraft_id_2": aircraft2Id,
    };

    try {
      final jsonData = await ApiService.post(url: uri, body: body);
      return ComparisonModel.fromJson(jsonData);
    } catch (e) {
      throw e.toString();
    }
  }
}

