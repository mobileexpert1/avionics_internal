import '../../../Database/db_helper.dart';

class AircraftListModel extends BaseModel {
  @override
  final String id;
  final String model;
  final bool isFavorite;
  final AircraftImage image;

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
      image: AircraftImage.fromJson(json['Images'] ?? {}),
    );
  }

  factory AircraftListModel.fromMap(Map<String, dynamic> map) {
    return AircraftListModel(
      id: map['id'] as String,
      model: map['model'] as String,
      isFavorite: map['isFavorite'] == 1,
      image: AircraftImage(
        url: map['imageUrl'] ?? '',
        cc: map['imageCc'] ?? '',
        isDefault: map['imageIsDefault'] == 'True',
      ),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'model': model,
      'isFavorite': isFavorite ? 1 : 0,
      'imageUrl': image.url,
      'imageCc': image.cc,
      'imageIsDefault': image.isDefault.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Aircraft_Model': model,
      'IsFavorite': isFavorite,
      'Images': image.toJson(),
    };
  }

  @override
  String get table => 'allAircraftsList';
}

class AircraftImage {
  final String url;
  final String cc;
  final bool isDefault;

  AircraftImage({
    required this.url,
    required this.cc,
    required this.isDefault,
  });

  factory AircraftImage.fromJson(Map<String, dynamic> json) {
    return AircraftImage(
      url: json['url'] ?? '',
      cc: json['cc'] ?? '',
      isDefault: json['is_default']?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'cc': cc,
      'is_default': isDefault.toString(),
    };
  }
}
