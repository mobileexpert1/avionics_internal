import '../../../Database/db_helper.dart';

class AircraftModel implements BaseModel {
  final String aircraftId;
  final String aircraftModel;
  final bool isFavorite;
  final String icaoTypeCode;
  final String image;
  final ManufacturerModel? manufacturer;

  @override
  String? userId;

  AircraftModel({
    required this.aircraftId,
    required this.aircraftModel,
    required this.isFavorite,
    required this.icaoTypeCode,
    required this.image,
    this.manufacturer,
    this.userId,
  });

  AircraftModel copyWith({
    String? aircraftId,
    String? aircraftModel,
    bool? isFavorite,
    String? icaoTypeCode,
    String? image,
    ManufacturerModel? manufacturer,
    String? userId,
  }) {
    return AircraftModel(
      aircraftId: aircraftId ?? this.aircraftId,
      aircraftModel: aircraftModel ?? this.aircraftModel,
      isFavorite: isFavorite ?? this.isFavorite,
      icaoTypeCode: icaoTypeCode ?? this.icaoTypeCode,
      image: image ?? this.image,
      manufacturer: manufacturer ?? this.manufacturer,
      userId: userId ?? this.userId,
    );
  }

  factory AircraftModel.fromJson(Map<String, dynamic> json) {
    return AircraftModel(
      aircraftId: json['id']?.toString() ?? '',
      aircraftModel:
          json['Aircraft_Model']?.toString() ??
          json['aircraftModel']?.toString() ??
          '-',
      isFavorite: (json['IsFavorite'] is bool)
          ? json['IsFavorite']
          : (json['IsFavorite'] == 1),
      icaoTypeCode:
          json['ICAO_Type_Code']?.toString() ??
          json['icaoTypeCode']?.toString() ??
          '',
      image: json['Image']?.toString() ?? json['image']?.toString() ?? '',
      manufacturer: json['Manufacturer'] != null
          ? ManufacturerModel.fromJson(
              Map<String, dynamic>.from(json['Manufacturer']),
            )
          : (json['manufacturerName'] != null
                ? ManufacturerModel(
                    id: json['manufacturerId']?.toString() ?? '',
                    companyName: json['manufacturerName']?.toString() ?? '',
                    logo: json['manufacturerLogo']?.toString() ?? '',
                    airlineLogo: json['airlineLogo']?.toString() ?? '',
                    airlineName: json['airlineName']?.toString() ?? '',
                  )
                : null),
      userId: json['user_id']?.toString(),
    );
  }

  @override
  String get table => 'selected_aircraft';

  @override
  String get id => aircraftId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'aircraftModel': aircraftModel,
      'manufacturerName': manufacturer?.companyName ?? '',
      'manufacturerLogo': manufacturer?.logo ?? '',
      'manufacturerId': manufacturer?.id ?? '',
      'airlineLogo': manufacturer?.airlineLogo ?? '',
      'airlineName': manufacturer?.airlineName ?? '',
      'user_id': userId,
      'icaoTypeCode': icaoTypeCode,
      'isFavorite': isFavorite ? 1 : 0,
      'image': image,
    };
  }
}

class ManufacturerModel {
  final String id;
  final String companyName;
  final String logo;
  final String airlineLogo;
  final String airlineName;

  ManufacturerModel({
    required this.id,
    required this.companyName,
    required this.logo,
    required this.airlineLogo,
    required this.airlineName,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    return ManufacturerModel(
      id: json['id']?.toString() ?? '',
      companyName:
          json['company_name']?.toString() ??
          json['companyName']?.toString() ??
          '',
      logo: json['logo']?.toString() ?? '',
      airlineLogo: json['airline_logo']?.toString() ?? '',
      airlineName: json['airline_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'logo': logo,
      'airline_logo': airlineLogo,
      'airline_name': airlineName,
    };
  }
}

class AircraftDetailsResponse {
  final String detail;
  final AircraftModel results;

  AircraftDetailsResponse({required this.detail, required this.results});

  factory AircraftDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AircraftDetailsResponse(
      detail: json['detail']?.toString() ?? '',
      results: AircraftModel.fromJson(
        Map<String, dynamic>.from(json['results'] ?? {}),
      ),
    );
  }
}
