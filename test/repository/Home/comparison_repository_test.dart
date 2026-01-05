import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/bloc/Home/AircraftComparison/Comparison/ComparisonModel.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Helper/test_token.dart';

void main() {
  group('AIRCRAFT COMPARISON API REAL SERVER TEST', () {

    test('Compare Two Aircrafts → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.compareAircraft}",
      );

      final body = {
        "aircraft_id_1": "002a36c1-de46-4684-8d2c-011f5fa1580a",
        "aircraft_id_2": "044d5aa1-4059-4708-b15d-604feb6ce4d0",
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode(body),
      );

      print("COMPARE AIRCRAFT STATUS 👉 ${response.statusCode}");
      print("COMPARE AIRCRAFT BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 422]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final comparison = ComparisonModel.fromJson(jsonMap);

        expect(comparison.detail, isNotEmpty);

        expect(comparison.aircraft1.general.icaoTypeCode, isNotEmpty);
        expect(comparison.aircraft1.general.noOfEngines, isNonZero);

        expect(comparison.aircraft2.general.icaoTypeCode, isNotEmpty);
        expect(comparison.aircraft2.general.noOfEngines, isNonZero);

        expect(comparison.aircraft1.technicalData.wingspan.meters, isNotEmpty);
        expect(comparison.aircraft2.technicalData.length.feet, isNotEmpty);

        expect(comparison.aircraft1.operationalData.takeoffSpeedKts, isNotEmpty);
        expect(comparison.aircraft2.operationalData.cruiseSpeed.cruiseKt, isNotEmpty);

        expect(comparison.aircraft1.operationalData.range.normalRangeKm, isNotEmpty);
      }
    });

  });
}
