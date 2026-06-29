import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/Custom_Pagination.dart';
import 'package:avionics_internal/bloc/Home/AllPlanesBloc/AllPlanes_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../Helper/test_token.dart';

void main() {
  group('ALL PLANES API REAL SERVER TEST', () {
    const selectedAirbusId = "a9739d15-8de9-4a82-bbef-5ea16dab9e67";
    const aircraftId = "dc15fdf7-bc9d-4094-8db1-254f592a7631";

    test('Fetch All Planes → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getListAirbus}$selectedAirbusId"
            "?page=1&max_page_size=10",
      );
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );
      print("ALL PLANES STATUS 👉 ${response.statusCode}");
      print("ALL PLANES BODY 👉 ${response.body}");
      expect(response.statusCode, anyOf([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final paginated = PaginatedList.fromJson(
          json: jsonData,
          fromJson: (e) => AircraftListModel.fromJson(e),
          currentPage: 1,
        );

        expect(paginated.results, isNotNull);
        expect(paginated.count, greaterThanOrEqualTo(0));

        if (paginated.count > 0) {
          expect(paginated.results.isNotEmpty, true);

          final first = paginated.results.first;

          expect(first.id, isNotEmpty);

          expect(
            (first.model != null && first.model!.isNotEmpty),
            true,
            reason: "Aircraft model should not be empty",
          );
        }
      }
    });

    test('Set Fav or Unfav Plane → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.saveUnSavePlane}",
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
        body: jsonEncode({"aircraft_id": aircraftId}),
      );

      print("SET FAV STATUS 👉 ${response.statusCode}");
      print("SET FAV BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        expect(jsonData['detail'], isNotEmpty);
      }
    });
  });
}
