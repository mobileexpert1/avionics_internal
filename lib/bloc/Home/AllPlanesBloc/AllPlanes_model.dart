import '../../../Database/db_helper.dart';

class AircraftListModel extends BaseModel {
  @override
  final String id;
  final String model;
  final String ICAOCode;
  final bool isFavorite;
  final String image;
  final String iCAOTypeCode;



  AircraftListModel({
    required this.id,
    required this.model,
    required this.ICAOCode,
    required this.isFavorite,
    required this.image,
    required this.iCAOTypeCode,
  });

  factory AircraftListModel.fromJson(Map<String, dynamic> json) {
    return AircraftListModel(
      id: json['id'] ?? '',
      model: json['Aircraft_Model'] ?? '',
      ICAOCode: json['ICAO_Type_Code'] ?? '',
      isFavorite: json['IsFavorite'] ?? false,
      image: json['Image'] ?? '',
      iCAOTypeCode: json['ICAO_Type_Code'] ?? '',
    );
  }

  factory AircraftListModel.fromMap(Map<String, dynamic> map) {
    return AircraftListModel(
      id: map['id'] as String,
      model: map['model'] as String,
      ICAOCode: map['ICAO_Type_Code'] as String,
      isFavorite: map['isFavorite'] == 1,
      image: map['Image'] as String,
      iCAOTypeCode: map['ICAO_Type_Code'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'ICAO_Type_Code': ICAOCode,
      'isFavorite': isFavorite ? 1 : 0,
      'Image': image,
      'ICAO_Type_Code': iCAOTypeCode,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Aircraft_Model': model,
      'ICAO_Type_Code': ICAOCode,
      'IsFavorite': isFavorite,
      'Image': image,
      'ICAO_Type_Code': iCAOTypeCode,
    };
  }

  @override
  String get table => 'allAircraftsList';
}
