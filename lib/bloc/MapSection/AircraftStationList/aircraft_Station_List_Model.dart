class AircraftStationListResponse {
  final String detail;
  final List<AircraftStationModel> data;

  AircraftStationListResponse({
    required this.detail,
    required this.data,
  });

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
  final int? runwayLength;
  final String? elev;
  final String? icao;

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
    this.runwayLength,
    this.elev,
    this.icao,
  });

  factory AircraftStationModel.fromJson(Map<String, dynamic> json) {
    return AircraftStationModel(
      id: json['id'] ?? '',
      iataCode: json['iata_code'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude_deg'] ?? 0).toDouble(),
      longitude: (json['longitude_deg'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      timezone: json['timezone'] ?? '',
      type: json['type'] ?? '',
      runwayLength: json['runway_length'],
      elev: json['elev'],
      icao: json['icao'],
    );
  }
}
