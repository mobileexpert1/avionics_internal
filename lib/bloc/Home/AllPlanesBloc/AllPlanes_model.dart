import '../../../Database/db_helper.dart';

class AircraftListModel extends BaseModel {
  @override
  final String id;
  final String model;
  final bool isFavorite;
  final String image;

  AircraftListModel({
    required this.id,
    required this.model,
    required this.isFavorite,
    required this.image,
  });

  factory AircraftListModel.fromJson(Map<String, dynamic> json) {
    return AircraftListModel(
      id: json['id'] ?? '',
      model: json['Aircraft_Model'] ?? '',
      isFavorite: json['IsFavorite'] ?? false,
      image: json['Image'] ?? '',
    );
  }

  factory AircraftListModel.fromMap(Map<String, dynamic> map) {
    return AircraftListModel(
      id: map['id'] as String,
      model: map['model'] as String,
      isFavorite: map['isFavorite'] == 1,
      image: map['Image'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'isFavorite': isFavorite ? 1 : 0,
      'Image': image,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Aircraft_Model': model,
      'IsFavorite': isFavorite,
      'Image': image,
    };
  }

  @override
  String get table => 'allAircraftsList';
}
