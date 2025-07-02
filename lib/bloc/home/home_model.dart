import 'package:avionics_internal/bloc/manufacturer/manufacturer_list_model.dart';

import '../../Database/db_helper.dart';

class HomeResponse {
  final List<ManufacturerListModel> manufacturers;
  final List<Flight> flights;
  final List<Favourite> favourites;

  HomeResponse({
    required this.manufacturers,
    required this.flights,
    required this.favourites,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    manufacturers: (json['manufacturer'] as List<dynamic>? ?? [])
        .map((e) => ManufacturerListModel.fromJson(e))
        .toList(),
    flights: (json['flight'] as List<dynamic>? ?? [])
        .map((e) => Flight.fromJson(e))
        .toList(),
    favourites: (json['favourite'] as List<dynamic>? ?? [])
        .map((e) => Favourite.fromJson(e))
        .toList(),
  );
}

class Flight extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String model;
  final String code;
  final String? image;
  final String companyName;
  final String? logo;
  final String flightId;

  Flight({
    required this.id,
    required this.model,
    required this.code,
    this.image,
    required this.companyName,
    this.logo,
    required this.flightId,
    this.userId,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json['id'] ?? '',
    model: json['model'] ?? '',
    code: json['code'] ?? '',
    image: json['image'],
    companyName: json['company_name'] ?? '',
    logo: json['logo'],
    flightId: json['flight_id'] ?? '',
    userId: json['user_id'],
  );

  factory Flight.fromMap(Map<String, dynamic> m) => Flight(
    id: m['id'],
    model: m['model'],
    code: m['code'],
    image: m['image'],
    companyName: m['company_name'],
    logo: m['logo'],
    flightId: m['flight_id'],
    userId: m['user_id'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'model': model,
    'code': code,
    'image': image,
    'company_name': companyName,
    'logo': logo,
    'flight_id': flightId,
    'user_id': userId,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'model': model,
    'code': code,
    'image': image,
    'company_name': companyName,
    'logo': logo,
    'flight_id': flightId,
  };

  @override
  String get table => 'flights';
}

class Favourite extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String model;
  final String? logo;

  Favourite({required this.id, required this.model, this.logo, this.userId});

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id: json['id'] ?? '',
    model: json['model'] ?? '',
    logo: json['logo'],
    userId: json['user_id'],
  );

  factory Favourite.fromMap(Map<String, dynamic> m) => Favourite(
    id: m['id'],
    model: m['model'],
    logo: m['logo'],
    userId: m['user_id'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'model': model,
    'logo': logo,
    'user_id': userId,
  };

  Map<String, dynamic> toJson() => {'id': id, 'model': model, 'logo': logo};

  @override
  String get table => 'favourites';
}
