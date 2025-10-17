import 'package:equatable/equatable.dart';

class FlightDetailResponse {
  final String? detail;
  final List<FlightAircraftDetail> flights;
  final FlightAircraftDetail? result;

  const FlightDetailResponse({
    this.detail,
    this.flights = const [],
    this.result,
  });

  factory FlightDetailResponse.fromJson(Map<String, dynamic> json) {
    // Case 1: List response (flights)
    if (json['data'] != null) {
      final List<dynamic> data = json['data'];
      return FlightDetailResponse(
        flights: data
            .map((item) => FlightAircraftDetail.fromJson(item))
            .toList(),
      );
    }

    // Case 2: Single result response (aircraft details)
    if (json['results'] != null) {
      return FlightDetailResponse(
        detail: json['detail'],

        // result: FlightAircraftDetail.fromJson(json['results']),
        result: FlightAircraftDetail.fromJson({
          ...json['results'],
          'orig_icao_airport': json['orig_icao_airport'],
          'dest_icao_airport': json['dest_icao_airport'],
        }),
      );
    }

    // Default empty
    return const FlightDetailResponse(flights: []);
  }
}

class FlightAircraftDetail extends Equatable {
  // Flight fields
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
  final String? flightTime;
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
  final String? squawk;
  final String? source;
  final int? vspeed;

  // Aircraft fields
  final String? aircraftModel;
  final bool? isFavorite;
  final String? icaoTypeCode;
  final String? image;
  final ManufacturerModel? manufacturer;
  final AirportModel? originAirport;
  final AirportModel? destinationAirport;

  const FlightAircraftDetail({
    // Flight
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
    this.landingRunway,
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
    this.squawk,
    this.source,
    this.vspeed,

    // Aircraft
    this.aircraftModel,
    this.isFavorite,
    this.icaoTypeCode,
    this.image,
    this.manufacturer,
    this.originAirport,
    this.destinationAirport,
  });

  factory FlightAircraftDetail.fromJson(Map<String, dynamic> json) {
    return FlightAircraftDetail(
      // Flight
      id: json['fr24_id'] ?? json['id'] ?? '',
      flightNumber: json['flight'],
      callsign: json['callsign'],
      operatingAs: json['operating_as'],
      paintedAs: json['painted_as'],
      type: json['type'] ?? json['ICAO_Type_Code'],
      registration: json['reg'],
      departureIcao: json['orig_icao'],
      departureIata: json['orig_iata'],
      takeoffTime: json['datetime_takeoff'] != null
          ? DateTime.tryParse(json['datetime_takeoff'])
          : null,
      takeoffRunway: json['runway_takeoff'],
      arrivalIcao: json['dest_icao'],
      arrivalIata: json['dest_iata'],
      actualArrivalIcao: json['dest_icao_actual'],
      actualArrivalIata: json['dest_iata_actual'],
      landingTime: json['datetime_landed'] != null
          ? DateTime.tryParse(json['datetime_landed'])
          : null,
      landingRunway: json['runway_landed'],
      flightTime: json['flight_time'] == null || json['flight_time'].toString().trim().isEmpty
          ? null
          : json['flight_time'].toString(),
      actualDistance: json['actual_distance']?.toDouble(),
      circleDistance: json['circle_distance']?.toDouble(),
      category: json['category'],
      hex: json['hex'],
      firstSeen: json['first_seen'] != null
          ? DateTime.tryParse(json['first_seen'])
          : null,
      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'])
          : null,
      flightEnded: json['flight_ended'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      track: json['track'],
      groundSpeed: json['ground_speed'],
      altitude: json['altitude'],
      eta: json['eta'] != null ? DateTime.tryParse(json['eta']) : null,
      squawk: json['squawk'],
      source: json['source'],
      vspeed: json['vspeed'],

      // Aircraft
      aircraftModel: json['Aircraft_Model'],
      isFavorite: json['IsFavorite'],
      icaoTypeCode: json['ICAO_Type_Code'],
      image: json['Image'],
      manufacturer: json['Manufacturer'] != null
          ? ManufacturerModel.fromJson(json['Manufacturer'])
          : null,

      //Aircports
      originAirport: json['orig_icao_airport'] != null &&
          json['orig_icao_airport'] is Map<String, dynamic>
          ? AirportModel.fromJson(json['orig_icao_airport'])
          : null,
      destinationAirport: json['dest_icao_airport'] != null &&
          json['dest_icao_airport'] is Map<String, dynamic>
          ? AirportModel.fromJson(json['dest_icao_airport'])
          : null,
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
    landingRunway,
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
    squawk,
    source,
    vspeed,
    aircraftModel,
    isFavorite,
    icaoTypeCode,
    image,
    manufacturer,
    originAirport,
    destinationAirport,
  ];
}

class ManufacturerModel {
  final String id;
  final String companyName;
  final String logo;

  const ManufacturerModel({
    required this.id,
    required this.companyName,
    required this.logo,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    return ManufacturerModel(
      id: json['id'] ?? '',
      companyName: json['company_name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'company_name': companyName, 'logo': logo};
  }
}

extension FlightAircraftDetailCopy on FlightAircraftDetail {
  FlightAircraftDetail copyWith({
    double? latitude,
    double? longitude,
    int? track,
    int? groundSpeed,
    int? altitude,
    DateTime? takeoffTime,
    DateTime? eta,
    String? flightNumber,
    String? callsign,
    String? registration,
    String? squawk,
    String? source,
    int? vspeed,
    String? flightTime,
    DateTime? firstSeen,       // new
    DateTime? lastSeen,        // new
    bool? flightEnded,         // new
    DateTime? landingTime,     // new
  }) {
    return FlightAircraftDetail(
      id: id,
      flightNumber: flightNumber ?? this.flightNumber,
      callsign: callsign ?? this.callsign,
      operatingAs: operatingAs,
      paintedAs: paintedAs,
      type: type,
      registration: registration ?? this.registration,
      departureIcao: departureIcao,
      departureIata: departureIata,
      takeoffTime: takeoffTime ?? this.takeoffTime,
      takeoffRunway: takeoffRunway,
      arrivalIcao: arrivalIcao,
      arrivalIata: arrivalIata,
      actualArrivalIcao: actualArrivalIcao,
      actualArrivalIata: actualArrivalIata,
      landingTime: landingTime ?? this.landingTime,       // updated
      landingRunway: landingRunway,
      flightTime: flightTime ?? this.flightTime,
      actualDistance: actualDistance,
      circleDistance: circleDistance,
      category: category,
      hex: hex,
      firstSeen: firstSeen ?? this.firstSeen,            // updated
      lastSeen: lastSeen ?? this.lastSeen,               // updated
      flightEnded: flightEnded ?? this.flightEnded,      // updated
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      track: track ?? this.track,
      groundSpeed: groundSpeed ?? this.groundSpeed,
      altitude: altitude ?? this.altitude,
      eta: eta ?? this.eta,
      squawk: squawk ?? this.squawk,
      source: source ?? this.source,
      vspeed: vspeed ?? this.vspeed,
      aircraftModel: aircraftModel,
      isFavorite: isFavorite,
      icaoTypeCode: icaoTypeCode,
      image: image,
      manufacturer: manufacturer,
      originAirport: originAirport,
      destinationAirport: destinationAirport,
    );
  }
}

class AirportModel {
  final String id;
  final String name;
  final String city;
  final String state;
  final String country;

  const AirportModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'state': state,
      'country': country,
    };
  }
}
