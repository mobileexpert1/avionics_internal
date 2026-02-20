import '../../../Database/db_helper.dart';

class AircraftListModel extends BaseModel {
  @override
  final String id;
  final String model;
  final String ICAOCode;
  final bool isFavorite;
  final bool isSaved;
  final String image;

  AircraftListModel({
    required this.id,
    required this.model,
    required this.ICAOCode,
    required this.isFavorite,
    required this.isSaved,
    required this.image,
  });

  factory AircraftListModel.fromJson(Map<String, dynamic> json) {
    return AircraftListModel(
      id: json['id'] ?? '',
      model: json['Aircraft_Model'] ?? '',
      ICAOCode: json['ICAO_Type_Code'] ?? '',
      isFavorite: json['IsFavorite'] ?? false,
      isSaved: json['isSaved'] ?? false,
      image: json['Image'] ?? '',
    );
  }

  factory AircraftListModel.fromMap(Map<String, dynamic> map) {
    return AircraftListModel(
      id: map['id'] as String,
      model: map['model'] as String,
      ICAOCode: map['ICAO_Type_Code'] as String,
      isFavorite: map['isFavorite'] == 1,
      isSaved: map['isSaved'] == 1,
      image: map['Image'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'ICAO_Type_Code': ICAOCode,
      'isFavorite': isFavorite ? 1 : 0,
      'isSaved': isSaved ? 1 : 0,
      'Image': image,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Aircraft_Model': model,
      'ICAO_Type_Code': ICAOCode,
      'IsFavorite': isFavorite,
      'isSaved': isSaved,
      'Image': image,
    };
  }

  @override
  String get table => 'allAircraftsList';
}
