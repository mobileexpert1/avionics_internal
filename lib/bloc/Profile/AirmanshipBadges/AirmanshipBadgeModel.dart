class AirmanshipBadgeModel {
  final String detail;
  final List<AirmanshipBadgeCategoryModel> data;

  AirmanshipBadgeModel({required this.detail, required this.data});

  factory AirmanshipBadgeModel.fromJson(Map<String, dynamic> json) {
    return AirmanshipBadgeModel(
      detail: json['detail'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AirmanshipBadgeCategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class AirmanshipBadgeCategoryModel {
  final String id;
  final String name;
  final List<AirmanshipBadgeItemModel> badges;

  AirmanshipBadgeCategoryModel({
    required this.id,
    required this.name,
    required this.badges,
  });

  factory AirmanshipBadgeCategoryModel.fromJson(Map<String, dynamic> json) {
    return AirmanshipBadgeCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      badges: (json['badges'] as List<dynamic>? ?? [])
          .map((e) => AirmanshipBadgeItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'badges': badges.map((e) => e.toJson()).toList(),
    };
  }
}

class AirmanshipBadgeItemModel {
  final String name;
  final String description;
  final String icon;
  final bool unlocked;

  AirmanshipBadgeItemModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.unlocked,
  });

  factory AirmanshipBadgeItemModel.fromJson(Map<String, dynamic> json) {
    return AirmanshipBadgeItemModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      unlocked: (json['unlocked'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'unlocked': unlocked,
    };
  }
}
