import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/Custom_Pagination.dart';
import 'package:avionics_internal/bloc/Home/manufacturer/manufacturer_list_model.dart';
import 'package:avionics_internal/bloc/Home/manufacturer/Manufacturer_detail_model.dart';

import '../../Helper/test_token.dart';

void main() {
  group('MANUFACTURER API REAL SERVER TEST', () {

    test('Fetch Manufacturer List → API → STATUS CODE CHECK', () async {
      final page = 1;
      const query = '';

      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getListManufacturer}"
            "?page=$page${query.isNotEmpty ? '&q=$query' : ''}",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("MANUFACTURER LIST STATUS 👉 ${response.statusCode}");
      print("MANUFACTURER LIST BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        final paginated = PaginatedList.fromJson(
          json: jsonMap,
          fromJson: (e) => ManufacturerListModel.fromJson(e),
          currentPage: page,
        );

        expect(paginated.results, isNotNull);
        expect(paginated.count, greaterThanOrEqualTo(0));
        expect(paginated.currentPage, page);

        /// Safe validation
        if (paginated.results.isNotEmpty) {
          final first = paginated.results.first;
          expect(first.id, isNotEmpty);
          expect(first.companyName, isNotEmpty);
        }
      }
    });

    test('Fetch Manufacturer Detail → API → STATUS CODE CHECK', () async {
      const manufacturerId = "00e64a2c-ddc0-4475-962a-f416a4d50ba9";

      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getListManufacturer}"
            "$manufacturerId",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("MANUFACTURER DETAIL STATUS 👉 ${response.statusCode}");
      print("MANUFACTURER DETAIL BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401, 404]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final detail = ManufacturerDetailResponse.fromJson(jsonData);

        expect(detail.detail, isNotEmpty);
        expect(detail.data, isNotNull);
        expect(detail.data!.id, isNotEmpty);

        expect(detail.data!.company, isNotNull);
        expect(detail.data!.company!.companyDescription, isNotEmpty);
        expect(detail.data!.company!.companyHistory, isNotEmpty);
      }
    });
  });
}
