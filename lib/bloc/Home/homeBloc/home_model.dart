import '../../../Database/db_helper.dart';
import '../manufacturer/manufacturer_list_model.dart';

class HomeResponse {
  final String detail;
  final bool isActiveSubscription;
  final List<ManufacturerListModel> manufacturers;
  final List<Flight> flights;
  final List<Favourite> favourites;

  HomeResponse({
    required this.detail,
    required this.isActiveSubscription,
    required this.manufacturers,
    required this.flights,
    required this.favourites,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    detail: json['detail'] ?? '',
    isActiveSubscription: json['is_active_subscription'] ?? false,
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
  final String id;
  final String aircraftModel;
  final String iCAOCode;
  final String image;

  Favourite({
    required this.id,
    required this.aircraftModel,
    required this.iCAOCode,
    required this.image,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) => Favourite(
    id: json['id'] ?? '',
    aircraftModel: json['Aircraft_Model'] ?? '',
    iCAOCode: json['ICAO_Type_Code'],
    image: json['Image'],
  );

  factory Favourite.fromMap(Map<String, dynamic> m) => Favourite(
    id: m['id'] ?? '',
    aircraftModel: m['Aircraft_Model'] ?? '',
    iCAOCode: m['ICAO_Type_Code'],
    image: m['Image'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'Aircraft_Model': aircraftModel,
    'ICAO_Type_Code': iCAOCode,
    'Image': image,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'Aircraft_Model': aircraftModel,
    'ICAO_Type_Code': iCAOCode,
    'Image': image,
  };

  @override
  String get table => 'favourites';
}
