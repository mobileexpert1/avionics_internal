import 'dart:convert';
import 'package:avionics_internal/bloc/MapSection/MapAircraftList/aircraft_List_Data_State.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import '../../Helper/test_token.dart';

void main() {
  group('AIRCRAFT LIST DATA REPOSITORY API REAL SERVER TEST', () {

    /// POST → Flying Aircraft List
    test('Fetch Flying Aircraft List → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiFunctionUrlMapSectionConstant.aircraftFlyingList}",
      );

      final aircraftIds = [
        "a9739d15-8de9-4a82-bbef-5ea16dab9e67",  // need flight in air
      ];

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode({
          "aircraft_id": aircraftIds,
        }),
      );

      print("FLYING AIRCRAFT STATUS 👉 ${response.statusCode}");
      print("FLYING AIRCRAFT BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401, 422]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final responseModel = AircraftListResponse.fromJson(jsonData);

        expect(responseModel.detail, isNotEmpty);
        expect(responseModel.data, isNotNull);
        expect(responseModel.data!.isNotEmpty, true);

        final first = responseModel.data!.first;
        expect(first.id, isNotEmpty);
      }
    });


    /// GET → Search Aircraft by ICAO
    test('Search Aircraft By ICAO → API → STATUS CODE CHECK', () async {
      const icaoCode = "A320";

      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "aircraft/icao-aircraft/$icaoCode",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("ICAO SEARCH STATUS 👉 ${response.statusCode}");
      print("ICAO SEARCH BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401, 404]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final responseModel = AircraftListResponse.fromJson(jsonData);

        expect(responseModel.detail, isNotEmpty);
        expect(responseModel.data, isNotNull);
        expect(responseModel.data!.isNotEmpty, true);

        final first = responseModel.data!.first;
        expect(first.icaoTypeCode ?? '', isNotEmpty);
      }
    });
  });
}
