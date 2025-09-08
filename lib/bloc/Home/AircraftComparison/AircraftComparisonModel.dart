class AircraftModel {
  final String id;
  final String aircraftModel;
  final bool isFavorite;
  final String icaoTypeCode;
  final String image;
  final ManufacturerModel? manufacturer;

  AircraftModel({
    required this.id,
    required this.aircraftModel,
    required this.isFavorite,
    required this.icaoTypeCode,
    required this.image,
    this.manufacturer,
  });

  factory AircraftModel.fromJson(Map<String, dynamic> json) {
    return AircraftModel(
      id: json['id'],
      aircraftModel: json['Aircraft_Model'],
      isFavorite: json['IsFavorite'],
      icaoTypeCode: json['ICAO_Type_Code'],
      image: json['Image'],
      manufacturer: json['Manufacturer'] != null
          ? ManufacturerModel.fromJson(json['Manufacturer'])
          : null,
    );
  }
}

class ManufacturerModel {
  final String id;
  final String companyName;
  final String logo;

  ManufacturerModel({
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
    return {
      'id': id,
      'company_name': companyName,
      'logo': logo,
    };
  }

}

class AircraftDetailsResponse {
  final String detail;
  final AircraftModel results;

  AircraftDetailsResponse({required this.detail, required this.results});

  factory AircraftDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AircraftDetailsResponse(
      detail: json['detail'] as String,
      results: AircraftModel.fromJson(json['results'] as Map<String, dynamic>),
    );
  }
}
