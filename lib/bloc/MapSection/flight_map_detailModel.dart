import 'package:equatable/equatable.dart';

class FlightDetailResponse {
  final List<FlightDetail> flights;

  FlightDetailResponse({required this.flights});

  factory FlightDetailResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'] ?? [];
    return FlightDetailResponse(
      flights: data.map((item) => FlightDetail.fromJson(item)).toList(),
    );
  }
}

class FlightDetail extends Equatable {
  final String id;
  final String? flightNumber;
  final String? callsign;
  final String? operatingAs;
  final String? paintedAs;
  final String? type;
  final String? registration;
  final String? departureIcao;
  final String? departureIata;
  final DateTime? takeoffTime;
  final String? takeoffRunway;
  final String? arrivalIcao;
  final String? arrivalIata;
  final String? actualArrivalIcao;
  final String? actualArrivalIata;
  final DateTime? landingTime;
  final String? landingRunway;
  final int? flightTime;
  final double? actualDistance;
  final double? circleDistance;
  final String? category;
  final String? hex;
  final DateTime? firstSeen;
  final DateTime? lastSeen;
  final bool? flightEnded;
  final double latitude;
  final double longitude;
  final int? track;
  final int? groundSpeed;
  final int? altitude;
  final DateTime? eta;

  FlightDetail({
    required this.id,
    this.flightNumber,
    this.callsign,
    this.operatingAs,
    this.paintedAs,
    this.type,
    this.registration,
    this.departureIcao,
    this.departureIata,
    this.takeoffTime,
    this.takeoffRunway,
    this.arrivalIcao,
    this.arrivalIata,
    this.actualArrivalIcao,
    this.actualArrivalIata,
    this.landingTime,
    this.flightTime,
    this.actualDistance,
    this.circleDistance,
    this.category,
    this.hex,
    this.firstSeen,
    this.lastSeen,
    this.flightEnded,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.track,
    this.groundSpeed,
    this.altitude,
    this.eta,
    this.landingRunway,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) {
    return FlightDetail(
      id: json['fr24_id'] ?? '',
      flightNumber: json['flight'],
      callsign: json['callsign'],
      operatingAs: json['operating_as'],
      paintedAs: json['painted_as'],
      type: json['type'],
      registration: json['reg'],
      departureIcao: json['orig_icao'],
      departureIata: json['orig_iata'],
      takeoffTime: json['datetime_takeoff'] != null
          ? DateTime.parse(json['datetime_takeoff'])
          : null,
      takeoffRunway: json['runway_takeoff'],
      arrivalIcao: json['dest_icao'],
      arrivalIata: json['dest_iata'],
      actualArrivalIcao: json['dest_icao_actual'],
      actualArrivalIata: json['dest_iata_actual'],
      landingTime: json['datetime_landed'] != null
          ? DateTime.parse(json['datetime_landed'])
          : null,
      flightTime: json['flight_time'],
      actualDistance: json['actual_distance']?.toDouble(),
      circleDistance: json['circle_distance']?.toDouble(),
      category: json['category'],
      hex: json['hex'],
      firstSeen: json['first_seen'] != null
          ? DateTime.parse(json['first_seen'])
          : null,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null,
      flightEnded: json['flight_ended'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      track: json['track'],
      groundSpeed: json['ground_speed'],
      altitude: json['altitude'],
      eta: json['eta'] != null ? DateTime.parse(json['eta']) : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    flightNumber,
    callsign,
    operatingAs,
    paintedAs,
    type,
    registration,
    departureIcao,
    departureIata,
    takeoffTime,
    takeoffRunway,
    arrivalIcao,
    arrivalIata,
    actualArrivalIcao,
    actualArrivalIata,
    landingTime,
    flightTime,
    actualDistance,
    circleDistance,
    category,
    hex,
    firstSeen,
    lastSeen,
    flightEnded,
    latitude,
    longitude,
    track,
    groundSpeed,
    altitude,
    eta,
  ];
}