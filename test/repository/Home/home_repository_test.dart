import 'dart:convert';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/bloc/Home/homeBloc/home_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../Helper/test_token.dart';

void main() {

  group('HOME REPOSITORY API REAL SERVER TEST', () {
    test('Fetch home Data → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "${ApiServiceUrlAirplaneConstant.getExploreData}",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${TestToken.instance.getToken}",
        },
      );

      print("HOME DATA STATUS 👉 ${response.statusCode}");
      print("HOME DATA BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final homeData = HomeResponse.fromJson(jsonData);

        expect(homeData.manufacturers, isNotNull);
        expect(homeData.manufacturers.isNotEmpty, true);
        expect(homeData.flights, isNotNull);
      }
    });

    // test('Fetch Map Key Value → API → STATUS CODE CHECK', () async {
    //   final url = Uri.parse(
    //     "${ApiBaseUrlConstant.baseUrl}"
    //         "${ApiFunctionUrlConstant.userService}"
    //         "${ApiServiceUrlConstant.authFetchMapKey}",
    //   );
    //
    //   const MethodChannel channel = MethodChannel('com.app/google_maps');
    //   channel.setMockMethodCallHandler((call) async {
    //     if (call.method == 'setGoogleMapsKey') {
    //       return true;
    //     }
    //     return null;
    //   });
    //
    //   final response = await http.get(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": "Bearer ${TestToken.instance.getToken}",
    //     },
    //   );
    //
    //   print("MAP KEY STATUS 👉 ${response.statusCode}");
    //   print("MAP KEY BODY 👉 ${response.body}");
    //
    //   expect(response.statusCode, isIn([200, 401]));
    //
    //   if (response.statusCode == 200) {
    //     final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    //     expect(jsonData['detail'], isNotEmpty);
    //   }
    // });
  });
}
