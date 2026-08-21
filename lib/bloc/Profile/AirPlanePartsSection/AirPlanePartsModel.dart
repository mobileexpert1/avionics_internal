class AirPlanePartsModel {
  final String id;
  final String name;
  final String image;
  final int collectedCount;
  final int totalCount;
  final bool isUnlocked;
  final String description;
  final String modelPath;
  final List<AirPlaneSubPartModel> subParts;
  final String aircraftPath;

  const AirPlanePartsModel({
    required this.id,
    required this.name,
    required this.image,
    this.collectedCount = 0,
    this.totalCount = 5,
    this.isUnlocked = false,
    this.description = '',
    this.subParts = const [],
    this.modelPath = '',
    this.aircraftPath = '',
  });

  double get progress {
    if (totalCount == 0) return 0;

    return (collectedCount / totalCount).clamp(0.0, 1.0);
  }

  AirPlanePartsModel copyWith({
    String? id,
    String? name,
    String? image,
    int? collectedCount,
    int? totalCount,
    bool? isUnlocked,
    String? description,
    List<AirPlaneSubPartModel>? subParts,
    String? modelPath,
    String? aircraftPath,
  }) {
    return AirPlanePartsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      collectedCount: collectedCount ?? this.collectedCount,
      totalCount: totalCount ?? this.totalCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      description: description ?? this.description,
      subParts: subParts ?? this.subParts,
      modelPath: modelPath ?? this.modelPath,
      aircraftPath: aircraftPath ?? this.aircraftPath,
    );
  }

  factory AirPlanePartsModel.fromJson(
    Map<String, dynamic> json, {
    String aircraftPath = '',
  }) {
    final unlockedKey = json['unlocked_key'] as Map<String, dynamic>? ?? {};

    return AirPlanePartsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['icon']?.toString() ?? '',

      collectedCount: (unlockedKey['unlocked'] as num?)?.toInt() ?? 0,

      totalCount: (unlockedKey['total'] as num?)?.toInt() ?? 5,

      isUnlocked: json['unlocked'] as bool? ?? false,

      description: json['description']?.toString() ?? '',

      modelPath: json['model_path']?.toString() ?? '',

      aircraftPath: aircraftPath,

      subParts: (json['component'] as List? ?? [])
          .map((e) => AirPlaneSubPartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AirPlaneSubPartModel {
  final String id;
  final String name;
  final String description;
  final bool isUnlocked;

  const AirPlaneSubPartModel({
    required this.id,
    required this.name,
    required this.description,
    this.isUnlocked = false,
  });

  AirPlaneSubPartModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isUnlocked,
  }) {
    return AirPlaneSubPartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  factory AirPlaneSubPartModel.fromJson(Map<String, dynamic> json) {
    return AirPlaneSubPartModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isUnlocked: json['unlocked'] as bool? ?? false,
    );
  }
}

class PlaneSpotterPart {
  final String id;
  final String name;
  final String icon;
  final String modelPath;

  const PlaneSpotterPart({
    required this.id,
    required this.name,
    required this.icon,
    required this.modelPath,
  });

  factory PlaneSpotterPart.fromJson(Map<String, dynamic> json) {
    return PlaneSpotterPart(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      modelPath: json['model_path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'model_path': modelPath,
  };
}
