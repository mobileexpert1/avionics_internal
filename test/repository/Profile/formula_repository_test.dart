import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/FormulaSection/formula_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/Constants/ConstantStrings.dart';

void main() {
  group('FORMULA API REAL SERVER TEST', () {
    test('Fetch All Formulas → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlAirplaneConstant.airplaneService}"
            "formulas",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("FORMULA STATUS 👉 ${response.statusCode}");
      print("FORMULA BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List<dynamic>;

        final formulas = jsonList
            .map((e) => FormulaModel.fromJson(e))
            .toList();

        expect(formulas, isNotNull);
        expect(formulas.isNotEmpty, true);
      }
    });
  });
}
