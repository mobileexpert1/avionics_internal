class AircraftStationListResponse {
  final String detail;
  final List<AircraftStationModel> data;

  AircraftStationListResponse({required this.detail, required this.data});

  factory AircraftStationListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] ?? [];
    return AircraftStationListResponse(
      detail: json['detail'] ?? '',
      data: list.map((e) => AircraftStationModel.fromJson(e)).toList(),
    );
  }
}

class AircraftStationModel {
  final String id;
  final String iataCode;
  final String name;
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String country;
  final String timezone;
  final String type;

  final String? icao;
  final String? elev;
  final String? runwayLength;

  final String? websiteUrl;
  final String? utcOffset;
  final String? numberOfRunways;
  final String? runwayDirection;
  final String? runwaySurfaceType;
  final String? numberOfTerminals;
  final String? annualMovements;
  final String? annualPassengerTraffic;

  String valueOrNA(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "N/A";
    }
    return value;
  }

  AircraftStationModel({
    required this.id,
    required this.iataCode,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.country,
    required this.timezone,
    required this.type,
    this.icao,
    this.elev,
    this.runwayLength,
    this.websiteUrl,
    this.utcOffset,
    this.numberOfRunways,
    this.runwayDirection,
    this.runwaySurfaceType,
    this.numberOfTerminals,
    this.annualMovements,
    this.annualPassengerTraffic,
  });

  factory AircraftStationModel.fromJson(Map<String, dynamic> json) {
    return AircraftStationModel(
      id: json['id'] ?? '',
      iataCode: json['iata_code'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude_deg'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude_deg'] as num?)?.toDouble() ?? 0.0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      timezone: json['timezone'] ?? '',
      type: json['type'] ?? '',
      icao: json['icao'],
      elev: json['elev']?.toString(),
      runwayLength: json['runway_length']?.toString(),
      websiteUrl: json['website_url'],
      utcOffset: json['utc_offset'],
      numberOfRunways: json['number_of_runways']?.toString(),
      runwayDirection: json['runway_direction'],
      runwaySurfaceType: json['runway_surface_type'],
      numberOfTerminals: json['number_of_terminals']?.toString(),
      annualMovements: json['annual_movements']?.toString(),
      annualPassengerTraffic: json['annual_passenger_traffic']?.toString(),
    );
  }
}
