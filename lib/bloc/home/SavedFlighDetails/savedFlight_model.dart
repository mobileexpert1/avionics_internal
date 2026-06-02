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
      detail: json['detail'] as String? ?? '',
      favorite:
          (json['favorite'] as List<dynamic>?)
              ?.map((e) => AircraftItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      saved:
          (json['saved'] as List<dynamic>?)
              ?.map((e) => AircraftItem.fromJson(e as Map<String, dynamic>))
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
  final AirlineModel? airline;

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
    this.airline,
  });

  factory AircraftItem.fromJson(Map<String, dynamic> json) {
    return AircraftItem(
      id: json['id'] as String? ?? '',
      aircraftModel: json['Aircraft_Model'] as String? ?? '',
      isFavorite: json['IsFavorite'] as bool? ?? false,
      icaoTypeCode: json['ICAO_Type_Code'] as String? ?? '',
      image: json['Image'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      callsign: json['callsign'] as String?,
      flightId: json['flight_id'] as String?,
      flightNumber: json['flight_number'] as String?,
      airline: json['airline'] != null
          ? AirlineModel.fromJson(json['airline'] as Map<String, dynamic>)
          : null,
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
      if (airline != null) 'airline': airline!.toJson(),
    };
  }
}

class AirlineModel {
  final String name;
  final String logo;

  const AirlineModel({required this.name, required this.logo});

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'logo': logo};
}
