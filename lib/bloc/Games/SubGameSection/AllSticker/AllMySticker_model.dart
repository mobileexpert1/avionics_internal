class AllMyStickerResponseModel {
  final String detail;
  final int totalUnlocked;
  final int total;
  final List<StickerModel> data;

  const AllMyStickerResponseModel({
    required this.detail,
    required this.data,
    required this.totalUnlocked,
    required this.total,
  });

  factory AllMyStickerResponseModel.fromJson(Map<String, dynamic> json) {
    return AllMyStickerResponseModel(
      detail: json['detail'] ?? '',
      total: json['total'] ?? 0,
      totalUnlocked: json['total_unlocked'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => StickerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class StickerModel {
  final String id;
  final String name;
  final String icon;
  final String orderChar;

  final AircraftSummary aircraftSummary;

  const StickerModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.orderChar,
    required this.aircraftSummary,
  });

  StickerModel copyWith({
    String? id,
    String? name,
    String? icon,
    String? orderChar,
    AircraftSummary? aircraftSummary,
  }) {
    return StickerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      orderChar: orderChar ?? this.orderChar,
      aircraftSummary: aircraftSummary ?? this.aircraftSummary,
    );
  }

  factory StickerModel.fromJson(Map<String, dynamic> json) {
    return StickerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      orderChar: json['order_char'] ?? '',
      aircraftSummary: AircraftSummary.fromJson(json['aircraft_summary'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'order_char': orderChar,
      'aircraft_summary': aircraftSummary.toJson(),
    };
  }
}

class AircraftSummary {
  final int unlocked;
  final int total;

  const AircraftSummary({required this.unlocked, required this.total});

  AircraftSummary copyWith({int? unlocked, int? total}) {
    return AircraftSummary(
      unlocked: unlocked ?? this.unlocked,
      total: total ?? this.total,
    );
  }

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
