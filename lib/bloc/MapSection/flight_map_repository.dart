import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';
import '../Home/AircraftComparison/AircraftComparisonModel.dart';
import 'flight_map_detailModel.dart';
import 'flight_map_model.dart';

class FlightRepository {
  final String _baseUrl = "https://fr24api.flightradar24.com/api/live";
  final String _baseUrlDetail = "https://fr24api.flightradar24.com/api/flight-summary/full";
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

  Future<Map<String, Object>> getFlightDetails({
    required String flightId,
    required String fromDateTime,
    required String toDateTime,
  }) async {
    // Correct endpoint and query params
    String url =
        "$_baseUrlDetail?flight_ids=$flightId&flight_datetime_from=$fromDateTime&flight_datetime_to=$toDateTime";
    final uri = Uri.parse(url);
    print('Fetching flight details with URL: $uri');

    final response = await http.get(uri, headers: _headers);
    print('API Response: Status=${response.statusCode}, Body=${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final flightResponse = FlightDetailResponse.fromJson(data);

      if (flightResponse.flights.isNotEmpty) {
        final flightDetail = flightResponse.flights.first;
        final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
        return {
          'flightDetail': flightDetail,
          'aircraftDetails': aircraftDetails,
        };
      } else {
        throw Exception("No flight data found for ID: $flightId");
      }
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  Future<AircraftModel> getAircraftDetails(String aircraftType) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlAirplaneConstant.airplaneService +
          ApiServiceUrlAirplaneConstant.getListAirbus + "details/$aircraftType",
    );
    try {
      final response = await ApiService.get(url: url);

      final aircraftResponse = AircraftDetailsResponse.fromJson(response);

      return aircraftResponse.results;
    } catch (e) {
      throw e.toString();
    }
  }

}