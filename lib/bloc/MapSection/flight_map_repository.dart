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
    int limit = 3,
  }) async {
    // Hardcode the aircraft types A318 and A320 in the URL
    String url = "$_baseUrl/flight-positions/full?bounds=$bounds&limit=$limit&aircraft=A318,A320,A20N,A21N&altitude_ranges=0-46000";

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
  }) async {
    String url =
        "$_baseUrlDetail?flight_ids=$flightId&flight_datetime_from=$fromDateTime&flight_datetime_to=$toDateTime";
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
      final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
      String bounds = (flightDetail.latitude != 0 || flightDetail.longitude != 0)
          ? _calculateBounds(Position(latitude: flightDetail.latitude, longitude: flightDetail.longitude))
          : "35.635648,25.635648,81.7212842,71.7212842";
      final flights = await getFlights(bounds: bounds, limit: 3);
      final matchingFlight = flights.firstWhere(
            (flight) => flight.hex == flightDetail.hex ||
            flight.callSign == flightDetail.callsign ||
            flight.flightNumber == flightDetail.flightNumber,
        orElse: () => throw Exception("No matching live flight found for ${flightDetail.flightNumber}"),
      ) as FlightModel?;

      final mergedDetail = mergeFlightAndAircraftDetails(
        flightDetail,
        aircraftDetails,
        matchingFlight,
      );

      return {
        'flightDetail': mergedDetail,
      };
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }


  String _calculateBounds(Position position, {double delta = 5.0}) {
    final north = position.latitude + delta;
    final south = position.latitude - delta;
    final east = position.longitude + delta;
    final west = position.longitude - delta;
    return "$north,$south,$east,$west";
  }

  FlightAircraftDetail mergeFlightAndAircraftDetails(
      FlightAircraftDetail flightDetail,
      List<FlightAircraftDetail> aircraftDetails,
      FlightModel? flightModel,
      ) {
    final aircraftDetail = aircraftDetails.isNotEmpty ? aircraftDetails.first : null;
    final aircraftFromModel = flightModel?.aircraftDetails;

    return FlightAircraftDetail(
      // Flight fields: Prefer FlightModel for live/accurate data if available
      id: flightDetail.id,
      flightNumber: flightModel?.flightNumber.isNotEmpty ?? false
          ? flightModel!.flightNumber
          : flightDetail.flightNumber,
      callsign: flightModel?.callSign.isNotEmpty ?? false
          ? flightModel!.callSign
          : flightDetail.callsign,
      operatingAs: flightModel?.operatingAs.isNotEmpty ?? false
          ? flightModel!.operatingAs
          : flightDetail.operatingAs,
      paintedAs: flightModel?.paintedAs.isNotEmpty ?? false
          ? flightModel!.paintedAs
          : flightDetail.paintedAs,
      type: flightModel?.type.isNotEmpty ?? false ? flightModel!.type : flightDetail.type,
      registration: flightModel?.registration.isNotEmpty ?? false
          ? flightModel!.registration
          : flightDetail.registration,
      departureIata: flightModel?.departureIata.isNotEmpty ?? false
          ? flightModel!.departureIata
          : flightDetail.departureIata,
      departureIcao: flightModel?.departureIcao.isNotEmpty ?? false
          ? flightModel!.departureIcao
          : flightDetail.departureIcao,
      arrivalIata: flightModel?.arrivalIata.isNotEmpty ?? false
          ? flightModel!.arrivalIata
          : flightDetail.arrivalIata,
      arrivalIcao: flightModel?.arrivalIcao.isNotEmpty ?? false
          ? flightModel!.arrivalIcao
          : flightDetail.arrivalIcao,
      eta: flightModel?.eta ?? flightDetail.eta,
      latitude: flightModel?.latitude ?? flightDetail.latitude,
      longitude: flightModel?.longitude ?? flightDetail.longitude,
      track: flightModel?.track ?? flightDetail.track,
      groundSpeed: flightModel?.groundSpeed ?? flightDetail.groundSpeed,
      altitude: flightModel?.altitude ?? flightDetail.altitude,

      // Aircraft fields: Prefer FlightModel.aircraftDetails, then aircraftDetail, then flightDetail
      aircraftModel: aircraftDetail?.aircraftModel ?? flightDetail.aircraftModel,
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
      hex: flightModel?.hex ?? flightDetail.hex,
      firstSeen: flightDetail.firstSeen,
      lastSeen: flightDetail.lastSeen,
      flightEnded: flightDetail.flightEnded,
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


class Position {
  final double latitude;
  final double longitude;
  Position({required this.latitude, required this.longitude});
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


// Future<Map<String, dynamic>> getFlightDetails({
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
//       // Merge flight and aircraft details
//       final mergedDetail = mergeFlightAndAircraftDetails(flightDetail, aircraftDetails);
//       return {
//         'flightDetail': mergedDetail,
//       };
//     } else if (flightResponse.flights.isNotEmpty) {
//       // Handle list of flights response
//       final flightDetail = flightResponse.flights.first;
//       final aircraftDetails = await getAircraftDetails(flightDetail.type ?? 'A318');
//       // Merge flight and aircraft details
//       final mergedDetail = mergeFlightAndAircraftDetails(flightDetail, aircraftDetails);
//       return {
//         'flightDetail': mergedDetail,
//       };
//     } else {
//       throw Exception("No flight data found for ID: $flightId");
//     }
//   } else {
//     throw Exception("Error ${response.statusCode}: ${response.body}");
//   }
// }


// FlightAircraftDetail mergeFlightAndAircraftDetails(
//     FlightAircraftDetail flightDetail,
//     List<FlightAircraftDetail> aircraftDetails,
//     ) {
//   // Use the first aircraft detail if available, otherwise keep flight detail fields
//   final aircraftDetail = aircraftDetails.isNotEmpty ? aircraftDetails.first : null;
//   return FlightAircraftDetail(
//     // Flight fields
//     id: flightDetail.id,
//     flightNumber: flightDetail.flightNumber,
//     callsign: flightDetail.callsign,
//     operatingAs: flightDetail.operatingAs,
//     paintedAs: flightDetail.paintedAs,
//     type: flightDetail.type,
//     registration: flightDetail.registration,
//     departureIcao: flightDetail.departureIcao,
//     departureIata: flightDetail.departureIata,
//     takeoffTime: flightDetail.takeoffTime,
//     takeoffRunway: flightDetail.takeoffRunway,
//     arrivalIcao: flightDetail.arrivalIcao,
//     arrivalIata: flightDetail.arrivalIata,
//     actualArrivalIcao: flightDetail.actualArrivalIcao,
//     actualArrivalIata: flightDetail.actualArrivalIata,
//     landingTime: flightDetail.landingTime,
//     landingRunway: flightDetail.landingRunway,
//     flightTime: flightDetail.flightTime,
//     actualDistance: flightDetail.actualDistance,
//     circleDistance: flightDetail.circleDistance,
//     category: flightDetail.category,
//     hex: flightDetail.hex,
//     firstSeen: flightDetail.firstSeen,
//     lastSeen: flightDetail.lastSeen,
//     flightEnded: flightDetail.flightEnded,
//     latitude: flightDetail.latitude,
//     longitude: flightDetail.longitude,
//     track: flightDetail.track,
//     groundSpeed: flightDetail.groundSpeed,
//     altitude: flightDetail.altitude,
//     eta: flightDetail.eta,
//     // Aircraft fields (from backend API)
//     aircraftModel: aircraftDetail?.aircraftModel ?? flightDetail.aircraftModel,
//     isFavorite: aircraftDetail?.isFavorite ?? flightDetail.isFavorite,
//     icaoTypeCode: aircraftDetail?.icaoTypeCode ?? flightDetail.icaoTypeCode,
//     image: aircraftDetail?.image ?? flightDetail.image,
//     manufacturer: aircraftDetail?.manufacturer ?? flightDetail.manufacturer,
//   );
// }