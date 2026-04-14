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

  SavedFlightResponse copyWith({
    String? detail,
    List<AircraftItem>? favorite,
    List<AircraftItem>? saved,
  }) {
    return SavedFlightResponse(
      detail: detail ?? this.detail,
      favorite: favorite ?? this.favorite,
      saved: saved ?? this.saved,
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
  final String? callsign;
  final String? flightNumber;
  final String? flightId;

  AircraftItem({
    required this.id,
    required this.aircraftModel,
    required this.isFavorite,
    required this.icaoTypeCode,
    required this.image,
    required this.isActive,
    this.callsign,
    this.flightNumber,
    this.flightId,
  });

  factory AircraftItem.fromJson(Map<String, dynamic> json) {
    return AircraftItem(
      id: json['id'] ?? '',
      aircraftModel: json['Aircraft_Model'] ?? '',
      isFavorite: json['IsFavorite'] ?? false,
      icaoTypeCode: json['ICAO_Type_Code'] ?? '',
      image: json['Image'] ?? '',
      isActive: json['is_active'] ?? false,
      callsign: json['callsign'],
      flightId: json['flight_id'],
      flightNumber: json['flight_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Aircraft_Model': aircraftModel,
      'IsFavorite': isFavorite,
      'ICAO_Type_Code': icaoTypeCode,
      'Image': image,
      'is_active': isActive,
      'callsign': callsign,
      'flight_id': flightId,
      'flight_number': flightNumber,
    };
  }
}
