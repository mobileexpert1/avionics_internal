import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/ConversionSection/conversion_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';

void main() {
  group('CONVERSION API REAL SERVER TEST', () {
    test('Fetch All Conversions → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "conversions",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("CONVERSION STATUS 👉 ${response.statusCode}");
      print("CONVERSION BODY 👉 ${response.body}");
      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;

        final conversions = jsonList
            .map((e) => ConversionCategory.fromJson(e))
            .toList();

        expect(conversions, isNotNull);
        expect(conversions.isNotEmpty, true);
      }
    });
  });
}
