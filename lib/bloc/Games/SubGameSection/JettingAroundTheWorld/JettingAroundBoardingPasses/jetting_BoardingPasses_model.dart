class JettingBoardingPassModel {
  final String detail;
  final List<BoardingPassModel> data;

  const JettingBoardingPassModel({required this.detail, required this.data});

  factory JettingBoardingPassModel.fromJson(Map<String, dynamic> json) {
    return JettingBoardingPassModel(
      detail: json['detail'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BoardingPassModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class BoardingPassModel {
  final String id;
  final String createdAt;
  final AirportModel fromAirport;
  final AirportModel toAirport;

  const BoardingPassModel({
    required this.id,
    required this.createdAt,
    required this.fromAirport,
    required this.toAirport,
  });

  factory BoardingPassModel.fromJson(Map<String, dynamic> json) {
    return BoardingPassModel(
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
      fromAirport: AirportModel.fromJson(
        json['from_airport'] ?? <String, dynamic>{},
      ),
      toAirport: AirportModel.fromJson(
        json['to_airport'] ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'from_airport': fromAirport.toJson(),
      'to_airport': toAirport.toJson(),
    };
  }
}

class AirportModel {
  final String colourCode;
  final String city;
  final String equatorDistance;
  final double distanceNM;
  final String flightSegment;
  final String country;

  const AirportModel({
    required this.city,
    required this.colourCode,
    required this.equatorDistance,
    required this.distanceNM,
    required this.flightSegment,
    required this.country,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      city: json['city'] ?? '',
      colourCode: json['colour_code'] ?? '',
      equatorDistance: json['equator_distance'] ?? '',
      distanceNM: json['distance_nm'] ?? '',
      flightSegment: json['flight_segment'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'colour_code': colourCode,
      'equator_distance': equatorDistance,
      'distance_nm': distanceNM,
      'flight_segment': flightSegment,
      'country': country,
    };
  }
}
