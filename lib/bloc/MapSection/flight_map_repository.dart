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
    String url = "$_baseUrl/flight-positions/full?bounds=$bounds&limit=$limit&aircraft=A318,A320&altitude_ranges=0-46000";

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

  // Future<Map<String, Object>> getFlightDetails({
  //   required String flightId,
  //   required String fromDateTime,
  //   required String toDateTime,
  // }) async {
  //   String url =
  //       "$_baseUrlDetail?flight_ids=$flightId&flight_datetime_from=$fromDateTime&flight_datetime_to=$toDateTime";
  //   final uri = Uri.parse(url);
  //   print('Fetching flight details with URL: $uri');
  //
  //   final response = await http.get(uri, headers: _headers);
  //   print('API Response: Status=${response.statusCode}, Body=${response.body}');
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final flightResponse = FlightDetailResponse.fromJson(data);
  //
  //     if (flightResponse.result != null) {
  //       // Handle single flight detail response
  //       final flightDetail = flightResponse.result!;
  //       final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
  //       return {
  //         'flightDetail': flightDetail,
  //         // Optionally include aircraftDetails if needed
  //       };
  //     } else if (flightResponse.flights.isNotEmpty) {
  //       // Handle list of flights response
  //       final flightDetail = flightResponse.flights.first;
  //       return {
  //         'flightDetail': flightDetail,
  //       };
  //     } else {
  //       throw Exception("No flight data found for ID: $flightId");
  //     }
  //   } else {
  //     throw Exception("Error ${response.statusCode}: ${response.body}");
  //   }
  // }
  //
  // Future<List<FlightAircraftDetail>> getAircraftDetails(String aircraftType) async {
  //   final url = Uri.parse(
  //     ApiBaseUrlConstant.baseUrl +
  //         ApiFunctionUrlAirplaneConstant.airplaneService +
  //         ApiServiceUrlAirplaneConstant.getListAirbus + "details/$aircraftType",
  //   );
  //   try {
  //     final response = await ApiService.get(url: url);
  //
  //     final aircraftResponse = FlightDetailResponse.fromJson(response);
  //
  //     return aircraftResponse.flights;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }


  Future<Map<String, dynamic>> getFlightDetails({
    required String flightId,
    required String fromDateTime,
    required String toDateTime,
  }) async {
    String url =
        "$_baseUrlDetail?flight_ids=$flightId&flight_datetime_from=$fromDateTime&flight_datetime_to=$toDateTime";
    final uri = Uri.parse(url);
    print('Fetching flight details with URL: $uri');

    final response = await http.get(uri, headers: _headers);
    print('API Response: Status=${response.statusCode}, Body=${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final flightResponse = FlightDetailResponse.fromJson(data);

      if (flightResponse.result != null) {
        // Handle single flight detail response
        final flightDetail = flightResponse.result!;
        final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
        // Merge flight and aircraft details
        final mergedDetail = mergeFlightAndAircraftDetails(flightDetail, aircraftDetails);
        return {
          'flightDetail': mergedDetail,
        };
      } else if (flightResponse.flights.isNotEmpty) {
        // Handle list of flights response
        final flightDetail = flightResponse.flights.first;
        final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
        // Merge flight and aircraft details
        final mergedDetail = mergeFlightAndAircraftDetails(flightDetail, aircraftDetails);
        return {
          'flightDetail': mergedDetail,
        };
      } else {
        throw Exception("No flight data found for ID: $flightId");
      }
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }


  FlightAircraftDetail mergeFlightAndAircraftDetails(
      FlightAircraftDetail flightDetail,
      List<FlightAircraftDetail> aircraftDetails,
      ) {
    // Use the first aircraft detail if available, otherwise keep flight detail fields
    final aircraftDetail = aircraftDetails.isNotEmpty ? aircraftDetails.first : null;
    return FlightAircraftDetail(
      // Flight fields
      id: flightDetail.id,
      flightNumber: flightDetail.flightNumber,
      callsign: flightDetail.callsign,
      operatingAs: flightDetail.operatingAs,
      paintedAs: flightDetail.paintedAs,
      type: flightDetail.type,
      registration: flightDetail.registration,
      departureIcao: flightDetail.departureIcao,
      departureIata: flightDetail.departureIata,
      takeoffTime: flightDetail.takeoffTime,
      takeoffRunway: flightDetail.takeoffRunway,
      arrivalIcao: flightDetail.arrivalIcao,
      arrivalIata: flightDetail.arrivalIata,
      actualArrivalIcao: flightDetail.actualArrivalIcao,
      actualArrivalIata: flightDetail.actualArrivalIata,
      landingTime: flightDetail.landingTime,
      landingRunway: flightDetail.landingRunway,
      flightTime: flightDetail.flightTime,
      actualDistance: flightDetail.actualDistance,
      circleDistance: flightDetail.circleDistance,
      category: flightDetail.category,
      hex: flightDetail.hex,
      firstSeen: flightDetail.firstSeen,
      lastSeen: flightDetail.lastSeen,
      flightEnded: flightDetail.flightEnded,
      latitude: flightDetail.latitude,
      longitude: flightDetail.longitude,
      track: flightDetail.track,
      groundSpeed: flightDetail.groundSpeed,
      altitude: flightDetail.altitude,
      eta: flightDetail.eta,
      // Aircraft fields (from backend API)
      aircraftModel: aircraftDetail?.aircraftModel ?? flightDetail.aircraftModel,
      isFavorite: aircraftDetail?.isFavorite ?? flightDetail.isFavorite,
      icaoTypeCode: aircraftDetail?.icaoTypeCode ?? flightDetail.icaoTypeCode,
      image: aircraftDetail?.image ?? flightDetail.image,
      manufacturer: aircraftDetail?.manufacturer ?? flightDetail.manufacturer,
    );
  }

  Future<List<FlightAircraftDetail>> getAircraftDetails(String aircraftType) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlAirplaneConstant.airplaneService}${ApiServiceUrlAirplaneConstant.getListAirbus}details/$aircraftType",
    );
    try {
      final response = await ApiService.get(url: url);
      final aircraftResponse = FlightDetailResponse.fromJson(response);

      // Ensure the result is wrapped in a list for consistency
      if (aircraftResponse.result != null) {
        return [aircraftResponse.result!];
      }
      return aircraftResponse.flights;
    } catch (e) {
      print('Error fetching aircraft details: $e');
      return []; // Return empty list on error to avoid breaking the merge
    }
  }
}