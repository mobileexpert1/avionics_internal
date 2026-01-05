import 'dart:convert';
import 'package:avionics_internal/bloc/Profile/GameBadges/gameBadges_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';

void main() {
  group('GAME BADGES API REAL SERVER TEST', () {

    /// ================= CALCULATION BADGES =================
    test('Fetch Calculation Badges → API → STATUS CODE CHECK', () async {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlGamesConstant.calculation}"
            "${ApiGameBadges.calculationBadges}",
      );

      final response = await http.get(uri);

      print("CALC BADGES STATUS 👉 ${response.statusCode}");
      print("CALC BADGES BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = BadgeResponse.fromJson(json);

        expect(model.data, isNotNull);
      }
    });

    /// ================= QUIZ BADGES =================
    test('Fetch Quiz Badges → API → STATUS CODE CHECK', () async {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlGamesConstant.quiz}"
            "${ApiGameBadges.quizBadges}/",
      );

      final response = await http.get(uri);

      print("QUIZ BADGES STATUS 👉 ${response.statusCode}");
      print("QUIZ BADGES BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = BadgeResponse.fromJson(json);

        expect(model.data, isNotNull);
      }
    });

    /// ================= BLACK BOX BADGES =================
    test('Fetch Black Box Badges → API → STATUS CODE CHECK', () async {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlGamesConstant.blackBox}"
            "${ApiGameBadges.blackBoxBadges}",
      );

      final response = await http.get(uri);

      print("BLACK BOX BADGES STATUS 👉 ${response.statusCode}");
      print("BLACK BOX BADGES BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = BadgeResponse.fromJson(json);

        expect(model.data, isNotNull);
      }
    });

    /// ================= ONE WORD BADGES =================
    test('Fetch One Word Badges → API → STATUS CODE CHECK', () async {
      final uri = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlGamesConstant.oneWord}"
            "${ApiGameBadges.oneWordBadges}",
      );

      final response = await http.get(uri);

      print("ONE WORD BADGES STATUS 👉 ${response.statusCode}");
      print("ONE WORD BADGES BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401]));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final model = BadgeResponse.fromJson(json);

        expect(model.data, isNotNull);
      }
    });
  });
}
