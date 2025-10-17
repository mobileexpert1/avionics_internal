import '../Home/AircraftComparison/AircraftComparisonModel.dart';

class FlightResponse {
  final List<FlightModel> flights;

  FlightResponse({required this.flights});

  factory FlightResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?) ?? [];
    return FlightResponse(
      flights: list
          .map((e) => FlightModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': flights.map((f) => f.toJson()).toList(),
  };

  @override
  String toString() => 'FlightResponse(${flights.length} flights)';
}

class FlightModel {
  final String id;
  final String flightNumber;
  final String callSign;
  final double latitude;
  final double longitude;
  final int track;
  final int altitude;
  final int groundSpeed;
  final int verticalSpeed;
  final String squawk;
  final DateTime timestamp;
  final String source;
  final String hex;
  final String type;
  final String registration;
  final String paintedAs;
  final String operatingAs;
  final String departureIata;
  final String departureIcao;
  final String arrivalIata;
  final String arrivalIcao;
  final DateTime? eta;
  final DateTime? takeoffTime;
  final String? flightTime;

  // ✅ New fields
  final DateTime? firstSeen;
  final DateTime? lastSeen;
  final bool? flightEnded;
  final DateTime? landingTime;

  final AircraftModel? aircraftDetails;

  FlightModel({
    required this.id,
    required this.flightNumber,
    required this.callSign,
    required this.latitude,
    required this.longitude,
    required this.track,
    required this.altitude,
    required this.groundSpeed,
    required this.verticalSpeed,
    required this.squawk,
    required this.timestamp,
    required this.source,
    required this.hex,
    required this.type,
    required this.registration,
    required this.paintedAs,
    required this.operatingAs,
    required this.departureIata,
    required this.departureIcao,
    required this.arrivalIata,
    required this.arrivalIcao,
    this.eta,
    this.takeoffTime,
    this.flightTime,
    this.firstSeen,
    this.lastSeen,
    this.flightEnded,
    this.landingTime,
    this.aircraftDetails,
  });

  FlightModel copyWith({
    String? id,
    String? flightNumber,
    String? callSign,
    double? latitude,
    double? longitude,
    int? track,
    int? altitude,
    int? groundSpeed,
    int? verticalSpeed,
    String? squawk,
    DateTime? timestamp,
    String? source,
    String? hex,
    String? type,
    String? registration,
    String? paintedAs,
    String? operatingAs,
    String? departureIata,
    String? departureIcao,
    String? arrivalIata,
    String? arrivalIcao,
    DateTime? eta,
    DateTime? takeoffTime,
    String? flightTime,
    DateTime? firstSeen,
    DateTime? lastSeen,
    bool? flightEnded,
    DateTime? landingTime,
    AircraftModel? aircraftDetails,
  }) {
    return FlightModel(
      id: id ?? this.id,
      flightNumber: flightNumber ?? this.flightNumber,
      callSign: callSign ?? this.callSign,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      track: track ?? this.track,
      altitude: altitude ?? this.altitude,
      groundSpeed: groundSpeed ?? this.groundSpeed,
      verticalSpeed: verticalSpeed ?? this.verticalSpeed,
      squawk: squawk ?? this.squawk,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      hex: hex ?? this.hex,
      type: type ?? this.type,
      registration: registration ?? this.registration,
      paintedAs: paintedAs ?? this.paintedAs,
      operatingAs: operatingAs ?? this.operatingAs,
      departureIata: departureIata ?? this.departureIata,
      departureIcao: departureIcao ?? this.departureIcao,
      arrivalIata: arrivalIata ?? this.arrivalIata,
      arrivalIcao: arrivalIcao ?? this.arrivalIcao,
      eta: eta ?? this.eta,
      takeoffTime: takeoffTime ?? this.takeoffTime,
      flightTime: flightTime ?? this.flightTime,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      flightEnded: flightEnded ?? this.flightEnded,
      landingTime: landingTime ?? this.landingTime,
      aircraftDetails: aircraftDetails ?? this.aircraftDetails,
    );
  }

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    num _num(dynamic v) =>
        (v is num) ? v : num.tryParse(v?.toString() ?? '') ?? 0;
    String _str(dynamic v) => v == null ? '' : v.toString();

    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        final n = int.tryParse(v.toString());
        if (n != null) {
          return DateTime.fromMillisecondsSinceEpoch(n * 1000, isUtc: true);
        }
      }
      return null;
    }

    return FlightModel(
      id: _str(json['fr24_id']),
      flightNumber: _str(json['flight']),
      callSign: _str(json['callsign']),
      latitude: _num(json['lat']).toDouble(),
      longitude: _num(json['lon']).toDouble(),
      track: _num(json['track']).toInt(),
      altitude: _num(json['alt']).toInt(),
      groundSpeed: _num(json['gspeed']).toInt(),
      verticalSpeed: _num(json['vspeed']).toInt(),
      squawk: _str(json['squawk']),
      timestamp: _parseDate(json['timestamp']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      source: _str(json['source']),
      hex: _str(json['hex']),
      type: _str(json['type']),
      registration: _str(json['reg']),
      paintedAs: _str(json['painted_as']),
      operatingAs: _str(json['operating_as']),
      departureIata: _str(json['orig_iata']),
      departureIcao: _str(json['orig_icao']),
      arrivalIata: _str(json['dest_iata']),
      arrivalIcao: _str(json['dest_icao']),
      eta: _parseDate(json['eta']),
      takeoffTime: _parseDate(json['datetime_takeoff']),
      flightTime: _str(json['flight_time']),

      // ✅ New fields
      firstSeen: _parseDate(json['first_seen']),
      lastSeen: _parseDate(json['last_seen']),
      flightEnded: json['flight_ended'] as bool?,
      landingTime: _parseDate(json['datetime_landed']),
    );
  }

  Map<String, dynamic> toJson() => {
    'fr24_id': id,
    'flight': flightNumber,
    'callsign': callSign,
    'lat': latitude,
    'lon': longitude,
    'track': track,
    'alt': altitude,
    'gspeed': groundSpeed,
    'vspeed': verticalSpeed,
    'squawk': squawk,
    'timestamp': timestamp.toUtc().toIso8601String(),
    'source': source,
    'hex': hex,
    'type': type,
    'reg': registration,
    'painted_as': paintedAs,
    'operating_as': operatingAs,
    'orig_iata': departureIata,
    'orig_icao': departureIcao,
    'dest_iata': arrivalIata,
    'dest_icao': arrivalIcao,
    'eta': eta?.toUtc().toIso8601String(),
    'takeoff_time': takeoffTime?.toUtc().toIso8601String(),
    'flight_time': flightTime,

    // ✅ New fields
    'first_seen': firstSeen?.toUtc().toIso8601String(),
    'last_seen': lastSeen?.toUtc().toIso8601String(),
    'flight_ended': flightEnded,
    'landing_time': landingTime?.toUtc().toIso8601String(),
  };

  @override
  String toString() =>
      'Flight($flightNumber, $callSign, alt:$altitude, takeoff:$takeoffTime, flightTime:$flightTime)';
}
