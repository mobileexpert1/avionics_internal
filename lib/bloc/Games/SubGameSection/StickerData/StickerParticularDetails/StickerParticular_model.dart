class StickerParticularResponse {
  final String detail;
  final StickerParticularCategory data;

  StickerParticularResponse({required this.detail, required this.data});

  factory StickerParticularResponse.fromJson(Map<String, dynamic> json) {
    return StickerParticularResponse(
      detail: json['detail'] ?? '',
      data: StickerParticularCategory.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.toJson()};
  }
}

class StickerParticularCategory {
  final String id;
  final String name;
  final String icon;
  final AircraftSummary aircraftSummary;
  final String orderChar;
  final List<StickerAircraft> aircrafts;

  StickerParticularCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.aircraftSummary,
    required this.orderChar,
    required this.aircrafts,
  });

  factory StickerParticularCategory.fromJson(Map<String, dynamic> json) {
    return StickerParticularCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      aircraftSummary: AircraftSummary.fromJson(json['aircraft_summary'] ?? {}),
      orderChar: json['order_char'] ?? '',
      aircrafts: (json['aircrafts'] as List<dynamic>? ?? [])
          .map((e) => StickerAircraft.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'aircraft_summary': aircraftSummary.toJson(),
      'order_char': orderChar,
      'aircrafts': aircrafts.map((e) => e.toJson()).toList(),
    };
  }
}

class AircraftSummary {
  final int unlocked;
  final int total;

  AircraftSummary({required this.unlocked, required this.total});

  factory AircraftSummary.fromJson(Map<String, dynamic> json) {
    return AircraftSummary(
      unlocked: json['unlocked'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'unlocked': unlocked, 'total': total};
  }
}

class StickerAircraft {
  final String id;
  final String icaoCode;
  final String model;
  final String image;
  final bool unlocked;

  StickerAircraft({
    required this.id,
    required this.icaoCode,
    required this.model,
    required this.image,
    required this.unlocked,
  });

  factory StickerAircraft.fromJson(Map<String, dynamic> json) {
    return StickerAircraft(
      id: json['id'] ?? '',
      icaoCode: json['icao_code'] ?? '',
      model: json['model'] ?? '',
      image: json['image'] ?? '',
      unlocked: json['unlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icao_code': icaoCode,
      'model': model,
      'image': image,
      'unlocked': unlocked,
    };
  }
}
