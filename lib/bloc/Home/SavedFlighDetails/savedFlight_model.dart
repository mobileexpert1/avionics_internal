class SavedFlightResponse {
  final String detail;
  final List<AircraftItem> favorite;
  final List<AircraftItem> saved;

  SavedFlightResponse({
    required this.detail,
    required this.favorite,
    required this.saved,
  });

  factory SavedFlightResponse.fromJson(Map<String, dynamic> json) {
    return SavedFlightResponse(
      detail: json['detail'] ?? '',
      favorite: (json['favorite'] as List<dynamic>?)
          ?.map((e) => AircraftItem.fromJson(e))
          .toList() ??
          [],
      saved: (json['saved'] as List<dynamic>?)
          ?.map((e) => AircraftItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AircraftItem {
  final String id;
  final String aircraftModel;
  final bool isFavorite;
  final String icaoTypeCode;
  final String image;
  final bool isActive;

  AircraftItem({
    required this.id,
    required this.aircraftModel,
    required this.isFavorite,
    required this.icaoTypeCode,
    required this.image,
    required this.isActive,
  });

  factory AircraftItem.fromJson(Map<String, dynamic> json) {
    return AircraftItem(
      id: json['id'] ?? '',
      aircraftModel: json['Aircraft_Model'] ?? '',
      isFavorite: json['IsFavorite'] ?? false,
      icaoTypeCode: json['ICAO_Type_Code'] ?? '',
      image: json['Image'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}
