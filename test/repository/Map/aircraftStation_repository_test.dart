import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/MapSection/AircraftStationList/aircraft_Station_List_Model.dart';

import '../../Helper/test_token.dart';

void main() {
  group('AIRCRAFT STATION LIST API REAL SERVER TEST', () {
    const latitude = "28.6139";
    const longitude = "77.2090";

    test('Fetch Aircraft Station List → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiFunctionUrlMapSectionConstant.aircraftStationList}",
      ).replace(queryParameters: {
        "latitude": latitude,
        "longitude": longitude,
      });

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("AIRCRAFT STATION STATUS 👉 ${response.statusCode}");
      print("AIRCRAFT STATION BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final stationResponse =
        AircraftStationListResponse.fromJson(jsonData);

        expect(stationResponse.detail, isNotEmpty);
        expect(stationResponse.data, isNotNull);
        expect(stationResponse.data!.isNotEmpty, true);

        final firstStation = stationResponse.data!.first;
        expect(firstStation.id, isNotEmpty);
        expect(firstStation.name, isNotEmpty);
      }
    });
  });
}
