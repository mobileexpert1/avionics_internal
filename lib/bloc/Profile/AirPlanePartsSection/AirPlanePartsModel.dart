class AirPlanePartsModel {
  final int id;
  final String name;
  final String image;
  final int collectedCount;
  final int totalCount;
  final bool isUnlocked;
  final String description;

  final List<AirPlaneSubPartModel> subParts;

  const AirPlanePartsModel({
    required this.id,
    required this.name,
    required this.image,
    this.collectedCount = 0,
    this.totalCount = 5,
    this.isUnlocked = false,
    required this.description,
    this.subParts = const [],
  });

  double get progress {
    if (totalCount == 0) return 0;
    return (collectedCount / totalCount).clamp(0.0, 1.0);
  }

  AirPlanePartsModel copyWith({
    int? id,
    String? name,
    String? image,
    int? collectedCount,
    int? totalCount,
    bool? isUnlocked,
    String? description,
    List<AirPlaneSubPartModel>? subParts,
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
    );
  }

  factory AirPlanePartsModel.fromJson(Map<String, dynamic> json) {
    return AirPlanePartsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      collectedCount: json['collected_count'] ?? 0,
      totalCount: json['total_count'] ?? 5,
      isUnlocked: json['is_unlocked'] ?? false,
      description: json['description'] ?? '',
      subParts: (json['sub_parts'] as List? ?? [])
          .map((e) => AirPlaneSubPartModel.fromJson(e))
          .toList(),
    );
  }
}


class AirPlaneSubPartModel {
  final int id;
  final String name;
  final String description;

  const AirPlaneSubPartModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory AirPlaneSubPartModel.fromJson(Map<String, dynamic> json) {
    return AirPlaneSubPartModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}