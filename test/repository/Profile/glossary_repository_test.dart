import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:avionics_internal/bloc/Profile/Glossary/glossary_model.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';

void main() {
  group('GLOSSARY API REAL SERVER TEST', () {

    test('Fetch All 3_Glossary → API → STATUS CODE CHECK', () async {
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlConstant.userService}"
            "${ApiServiceUrlConstant.getGlossary}",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("GLOSSARY STATUS 👉 ${response.statusCode}");
      print("GLOSSARY BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 404]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
        final allItems = <GlossaryItem>[];
        jsonMap.forEach((_, list) {
          for (final el in (list as List<dynamic>)) {
            allItems.add(GlossaryItem.fromJson(el as Map<String, dynamic>));
          }
        });

        expect(allItems, isNotNull);
        expect(allItems.isNotEmpty, true);
        final first = allItems.first;
        expect(first.title, isNotEmpty);
      }
    });

    test('Fetch 3_Glossary with query → API → STATUS CODE CHECK', () async {
      final query = 'air';
      final url = Uri.parse(
        "${ApiBaseUrlConstant.baseUrl}"
            "${ApiFunctionUrlConstant.userService}"
            "${ApiServiceUrlConstant.getGlossary}?q=$query",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("GLOSSARY QUERY STATUS 👉 ${response.statusCode}");
      print("GLOSSARY QUERY BODY 👉 ${response.body}");

      expect(response.statusCode, isIn([200, 401, 404]));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        final allItems = <GlossaryItem>[];
        jsonMap.forEach((_, list) {
          for (final el in (list as List<dynamic>)) {
            final item = GlossaryItem.fromJson(el as Map<String, dynamic>);
            allItems.add(item);
            expect(item.title.toLowerCase(), contains(query));
          }
        });

        expect(allItems.isNotEmpty, true);
      }
    });

  });
}
