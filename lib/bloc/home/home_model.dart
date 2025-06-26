import '../../Database/db_helper.dart';
import '../manufacturer/manufacturer_model.dart';

class HomeResponse {
  final List<Manufacturer> manufacturers;
  final List<Flight> flights;
  final List<Favourite> favourites;

  HomeResponse({
    required this.manufacturers,
    required this.flights,
    required this.favourites,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      manufacturers: (json['manufacturer'] as List<dynamic>?)
          ?.map((x) => Manufacturer.fromJson(x))
          .toList() ??
          [],
      flights: (json['flight'] as List<dynamic>?)
          ?.map((x) => Flight.fromJson(x))
          .toList() ??
          [],
      favourites: (json['favourite'] as List<dynamic>?)
          ?.map((x) => Favourite.fromJson(x))
          .toList() ??
          [],
    );
  }

}

class Flight implements BaseModel {
  final String id;
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
  });


  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
    id: json['id'] ?? '',
    model: json['model'] ?? '',
    code: json['code'] ?? '',
    image: json['image'],
    companyName: json['company_name'] ?? '',
    logo: json['logo'],
    flightId: json['flight_id'] ?? '',
  );

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

  factory Flight.fromMap(Map<String, dynamic> m) => Flight(
    id: m['id'] as String,
    model: m['model'] as String,
    code: m['code'] as String,
    image: m['image'] as String?,
    companyName: m['company_name'] as String,
    logo: m['logo'] as String?,
    flightId: m['flight_id'] as String,
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
  };
}


class Favourite implements BaseModel {
  final String id;
  final String model;
  final String? logo;

  Favourite({
    required this.id,
    required this.model,
    this.logo,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id: json['id'] ?? '',
    model: json['model'] ?? '',
    logo: json['logo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'model': model,
    'logo': logo,
  };


  @override
  String get table => 'favourites';

  factory Favourite.fromMap(Map<String, dynamic> m) => Favourite(
    id: m['id'] as String,
    model: m['model'] as String,
    logo: m['logo'] as String?,
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'model': model,
    'logo': logo,
  };
}



