import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/Home/AirCraftDetail/airCraftDetail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../Helper/test_token.dart';


void main() {
  group('AIRCRAFT DETAIL API REAL SERVER TEST', () {
    const aircraftId = "002a36c1-de46-4684-8d2c-011f5fa1580a";
    const icaoCode = "A320";

    test('Fetch Aircraft by ID → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiFunctionUrlAirplaneConstant.aircraftDetail}$aircraftId",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("AIRCRAFT BY ID STATUS 👉 ${response.statusCode}");
      print("AIRCRAFT BY ID BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final aircraft = AirCraftDetailResponse.fromJson(jsonData);

        expect(aircraft, isNotNull);
        expect(aircraft.detail, isNotEmpty);
      }
    });

    test('Fetch Aircraft by ICAO Code → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiFunctionUrlAirplaneConstant.aircraftDetailIcaoCode}$icaoCode",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("AIRCRAFT BY ICAO STATUS 👉 ${response.statusCode}");
      print("AIRCRAFT BY ICAO BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final aircraft = AirCraftDetailResponse.fromJson(jsonData);

        expect(aircraft, isNotNull);
        expect(aircraft.detail, isNotEmpty);
      }
    });
  });
}
