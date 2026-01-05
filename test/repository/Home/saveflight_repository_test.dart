import 'dart:convert';
import 'package:avionics_internal/bloc/Home/SavedFlighDetails/savedFlight_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';

import '../../Helper/test_token.dart';

void main() {
  group('SAVED FLIGHT API REAL SERVER TEST', () {

    test('Fetch Saved & Favorite Aircrafts → API → STATUS CODE CHECK', () async {

      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getListAirbus}save-favorite",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("SAVED FLIGHT STATUS 👉 ${response.statusCode}");
      print("SAVED FLIGHT BODY 👉 ${response.body}");

      expect(response.statusCode, anyOf([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final savedResponse = SavedFlightResponse.fromJson(jsonData);

        expect(savedResponse.detail, isNotEmpty);

        if (savedResponse.saved != null) {
          expect(savedResponse.saved, isA<List>());
        }

        if (savedResponse.favorite != null) {
          expect(savedResponse.favorite, isA<List>());
        }

        if (savedResponse.saved != null &&
            savedResponse.saved!.isNotEmpty) {
          final first = savedResponse.saved!.first;
          expect(first.id, isNotEmpty);
        }
      }
    });
  });
}
