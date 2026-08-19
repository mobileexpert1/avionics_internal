class JettingTheWorldModel {
  final String detail;
  final List<AirportPerItemModel> data;

  JettingTheWorldModel({required this.detail, required this.data});

  factory JettingTheWorldModel.fromJson(Map<String, dynamic> json) {
    return JettingTheWorldModel(
      detail: json['detail'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AirportPerItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class AirportPerItemModel {
  final String id;
  final String city;
  final String country;
  final String icao;
  final String iata;
  final String equatorDistance;
  final String flightSegment1;
  final String flightSegment2;
  final double distanceNm;
  final double latitude;
  final double longitude;
  final bool unlocked;
  final bool current;

  AirportPerItemModel({
    required this.id,
    required this.city,
    required this.country,
    required this.icao,
    required this.iata,
    required this.equatorDistance,
    required this.flightSegment1,
    required this.flightSegment2,
    required this.distanceNm,
    required this.latitude,
    required this.longitude,
    required this.unlocked,
    required this.current,
  });

  factory AirportPerItemModel.fromJson(Map<String, dynamic> json) {
    return AirportPerItemModel(
      id: json['id'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      icao: json['icao'] ?? '',
      iata: json['iata'] ?? '',
      equatorDistance: json['equator_distance'] ?? '',
      flightSegment1: json['flight_segment_1'] ?? '',
      flightSegment2: json['flight_segment_2'] ?? '',
      distanceNm: (json['distance_nm'] as num?)?.toDouble() ?? 0.0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      unlocked: (json['unlocked'] as bool?) ?? false,
      current: (json['current'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'country': country,
      'icao': icao,
      'iata': iata,
      'equator_distance': equatorDistance,
      'flight_segment_1': flightSegment1,
      'flight_segment_2': flightSegment2,
      'distance_nm': distanceNm,
      'latitude': latitude,
      'longitude': longitude,
      'unlocked': unlocked,
      'current': current,
    };
  }
}
