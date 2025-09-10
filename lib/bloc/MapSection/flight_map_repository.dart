import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';
import 'flight_map_detailModel.dart';
import 'flight_map_model.dart';

class FlightRepository {
  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'Accept-Version': 'v1',
    'Authorization':
        'Bearer 0196f4a5-73b4-7219-98bc-7daf81cfc59f|5VQhYisoEAOc9iQwNpOoTviX5ufQUcRABLj9eol711b82e65',
  };

  Future<List<FlightModel>> getFlights({
    required String bounds,
    int limit = 3,
  }) async {
    String url =
        "${MapFlightAircraftSectionConstant.baseUrl}/flight-positions/full?bounds=$bounds&limit=$limit&aircraft=A318,A320,A20N,A21N&altitude_ranges=0-46000";

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

  Future<List<FlightModel>> getParticularFlightDetails({
    required String bounds,
    required String flightId,
  }) async {
    String url =
        "${MapFlightAircraftSectionConstant.baseUrl}/flight-positions/full?bounds=$bounds&flights=$flightId";

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

  Future<Map<String, dynamic>> getFlightDetails({
    required String flightId,
    required String fromDateTime,
    required String toDateTime,
    FlightModel? flightModel,
  }) async {
    String url =
        "${MapFlightAircraftSectionConstant.baseUrlDetail}?flight_ids=$flightId&flight_datetime_from=$fromDateTime&flight_datetime_to=$toDateTime";
    final uri = Uri.parse(url);
    print('Fetching flight details with URL: $uri');

    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final flightResponse = FlightDetailResponse.fromJson(data);

      FlightAircraftDetail flightDetail;
      if (flightResponse.result != null) {
        flightDetail = flightResponse.result!;
      } else if (flightResponse.flights.isNotEmpty) {
        flightDetail = flightResponse.flights.first;
      } else {
        throw Exception("No flight data found for ID: $flightId");
      }

      final aircraftDetails = await getAircraftDetails(
        flightDetail.type ?? 'A318',
      );

      final mergedDetail = mergeFlightAndAircraftDetails(
        flightDetail,
        aircraftDetails,
      );

      return {'flightDetail': mergedDetail, 'flightModel': flightModel};
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  FlightAircraftDetail mergeFlightAndAircraftDetails(
    FlightAircraftDetail flightDetail,
    List<FlightAircraftDetail> aircraftDetails,
  ) {
    final aircraftDetail = aircraftDetails.isNotEmpty
        ? aircraftDetails.first
        : null;

    return FlightAircraftDetail(
      id: flightDetail.id,
      flightNumber: flightDetail.flightNumber,
      callsign: flightDetail.callsign,
      operatingAs: flightDetail.operatingAs,
      paintedAs: flightDetail.paintedAs,
      type: flightDetail.type,
      registration: flightDetail.registration,
      departureIata: flightDetail.departureIata,
      departureIcao: flightDetail.departureIcao,
      arrivalIata: flightDetail.arrivalIata,
      arrivalIcao: flightDetail.arrivalIcao,
      eta: flightDetail.eta,
      latitude: flightDetail.latitude,
      longitude: flightDetail.longitude,
      track: flightDetail.track,
      groundSpeed: flightDetail.groundSpeed,
      altitude: flightDetail.altitude,

      // Aircraft fields:
      aircraftModel:
          aircraftDetail?.aircraftModel ?? flightDetail.aircraftModel,
      isFavorite: aircraftDetail?.isFavorite ?? flightDetail.isFavorite,
      icaoTypeCode: aircraftDetail?.icaoTypeCode ?? flightDetail.icaoTypeCode,
      image: aircraftDetail?.image ?? flightDetail.image,
      manufacturer: aircraftDetail?.manufacturer ?? flightDetail.manufacturer,

      // Preserve other fields from flightDetail
      takeoffTime: flightDetail.takeoffTime,
      takeoffRunway: flightDetail.takeoffRunway,
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
    );
  }

  Future<List<FlightAircraftDetail>> getAircraftDetails(
    String aircraftType,
  ) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlAirplaneConstant.airplaneService}${ApiServiceUrlAirplaneConstant.getListAirbus}details/$aircraftType",
    );
    try {
      final response = await ApiService.get(url: url);
      final aircraftResponse = FlightDetailResponse.fromJson(response);

      if (aircraftResponse.result != null) {
        return [aircraftResponse.result!];
      }
      return aircraftResponse.flights;
    } catch (e) {
      print('Error fetching aircraft details: $e');
      return [];
    }
  }
}

class Position {
  final double latitude;
  final double longitude;

  Position({required this.latitude, required this.longitude});
}
