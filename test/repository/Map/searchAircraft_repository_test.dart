import 'dart:convert';
import 'package:avionics_internal/bloc/MapSection/MapSeacrhAircraftList/map_Search_Aircraft_List_Model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:avionics_internal/Constants/ConstantStrings.dart';

void main() {
  group(
    'MAP SEARCH AIRCRAFT LIST API REAL SERVER TEST',
        () {
      test(
        'Search Live Flights → API → STATUS CODE CHECK',
            () async {
          const String searchQuery = "A320";

          final url = Uri.parse(
            "${MapFlightAircraftSectionConstant.baseUrlSearch}"
                "$searchQuery&limit=10&type=live",
          );

          final response = await http.get(url);

          print("LIVE SEARCH STATUS 👉 ${response.statusCode}");
          print("LIVE SEARCH BODY 👉 ${response.body}");

          expect(response.statusCode, 200);

          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          final model = MapSearchAircraftListModel.fromJson(jsonData);

          expect(model, isNotNull);

          expect(model.stats, isNotNull);
          expect(model.stats.total, isA<int>());
          expect(model.stats.count, isA<int>());

          expect(model.results, isA<List>());

          if (model.results.isNotEmpty) {
            final flight = model.results.first;

            expect(flight.id, isNotEmpty);
            expect(flight.label, isNotEmpty);
            expect(flight.type, isNotEmpty);
            expect(flight.match, isNotEmpty);

            expect(flight.detail, isNotNull);
            expect(flight.detail.lat, isA<double>());
            expect(flight.detail.lon, isA<double>());
          }
        },
      );
    },
  );
}
