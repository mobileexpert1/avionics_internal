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


// class ManufacturerHome {
//   final String id;
//   final String companyName;
//   final String? logo;
//
//   ManufacturerHome({
//     required this.id,
//     required this.companyName,
//     this.logo,
//   });
//
//   factory ManufacturerHome.fromJson(Map<String, dynamic> json) {
//     return ManufacturerHome(
//       id: json['id'] ?? '',
//       companyName: json['company_name'] ?? '',
//       logo: json['logo'] ?? '',
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'company_name': companyName,
//       'logo': logo,
//     };
//   }
// }


class Flight {
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

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] ?? '',
      model: json['model'] ?? '',
      code: json['code'] ?? '',
      image: json['image'],
      companyName: json['company_name'] ?? '',
      logo: json['logo'],
      flightId: json['flight_id'] ?? '',
    );
  }
}


class Favourite {
  final String id;
  final String model;
  final String? logo;

  Favourite({
    required this.id,
    required this.model,
    this.logo,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['id'] ?? '',
      model: json['model'] ?? '',
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'logo': logo,
    };
  }
}



