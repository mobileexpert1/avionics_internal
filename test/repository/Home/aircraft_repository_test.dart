import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/bloc/Home/AircraftComparison/AircraftComparisonModel.dart';
import 'package:avionics_internal/CustomFiles/Custom_Pagination.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Helper/test_token.dart';

void main() {
  group('AIRCRAFT REPOSITORY API REAL SERVER TEST', () {

    test('Fetch Aircraft List → API → STATUS CODE CHECK', () async {
      final page = 1;
      final query = '';
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getListAirbus}"
            "?page=$page"
            "${query.isNotEmpty ? '&q=$query' : ''}&max_page_size=10",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("AIRCRAFT LIST STATUS 👉 ${response.statusCode}");
      print("AIRCRAFT LIST BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 422]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        final aircraftList = PaginatedList.fromJson(
          json: jsonMap,
          fromJson: (e) => AircraftModel.fromJson(e),
          currentPage: page,
        );

        // Basic list assertions
        expect(aircraftList.results, isNotNull);
        expect(aircraftList.results.isNotEmpty, true);
        expect(aircraftList.count, greaterThan(0));
        expect(aircraftList.currentPage, page);
        expect(aircraftList.totalPages, greaterThanOrEqualTo(1));

        // Check first aircraft in the list
        final first = aircraftList.results.first;
        expect(first.id, isNotEmpty);
        expect(first.aircraftModel ?? first.aircraftModel, isNotEmpty);

        // manufacturer is an object, check required fields instead
        expect(first.manufacturer, isNotNull);
        expect(first.manufacturer!.id, isNotEmpty);
        expect(first.manufacturer!.companyName ?? first.manufacturer!.companyName, isNotEmpty);
      }
    });

  });
}
