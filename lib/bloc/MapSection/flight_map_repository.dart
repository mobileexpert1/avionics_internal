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
    int limit = 1,
  }) async {
    final uri = Uri.parse("$_baseUrl/flight-positions/full?bounds=$bounds&limit=$limit");

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return FlightModel.fromApiResponse(data);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}
