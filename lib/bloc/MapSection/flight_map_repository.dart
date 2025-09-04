// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'flight_map_model.dart';
//
// class FlightRepository {
//   final String _baseUrl = "https://fr24api.flightradar24.com/api/live";
//   final Map<String, String> _headers = {
//     'Accept': 'application/json',
//     'Accept-Version': 'v1',
//     'Authorization': 'Bearer 0196f4a5-73b4-7219-98bc-7daf81cfc59f|5VQhYisoEAOc9iQwNpOoTviX5ufQUcRABLj9eol711b82e65',
//   };
//
//   Future<List<FlightModel>> getFlights({
//     required String bounds,
//     int limit = 5,
//   }) async {
//     final uri = Uri.parse("$_baseUrl/flight-positions/full?bounds=$bounds&limit=$limit");
//     print('Fetching flights with URL: $uri');
//
//     final response = await http.get(uri, headers: _headers);
//     print('API Response: Status=${response.statusCode}, Body=${response.body}');
//
//     if (response.statusCode == 200) {
//       try {
//         final data = json.decode(response.body);
//         final flightResponse = FlightResponse.fromJson(data);
//         return flightResponse.flights;
//       } catch (e) {
//         print('Error parsing flight data: $e');
//         throw Exception("Failed to parse flight data: $e");
//       }
//     } else {
//       throw Exception("Error ${response.statusCode}: ${response.body}");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'flight_map_model.dart';

class FlightRepository {
  final String _baseUrl = "https://fr24api.flightradar24.com/api/live";
  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Accept-Version': 'v1',
    'Authorization': 'Bearer 0196f4a5-73b4-7219-98bc-7daf81cfc59f|5VQhYisoEAOc9iQwNpOoTviX5ufQUcRABLj9eol711b82e65',
  };

  Future<List<FlightModel>> getFlights({
    required String bounds,
    int limit = 5,
  }) async {
    // Hardcode the aircraft types A318 and A320 in the URL
    String url = "$_baseUrl/flight-positions/full?bounds=$bounds&limit=$limit&aircraft=A318,A320";

    final uri = Uri.parse(url);
    print('Fetching flights with URL: $uri');

    final response = await http.get(uri, headers: _headers);
    print('API Response: Status=${response.statusCode}, Body=${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final flightResponse = FlightResponse.fromJson(data);
      return flightResponse.flights;
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}