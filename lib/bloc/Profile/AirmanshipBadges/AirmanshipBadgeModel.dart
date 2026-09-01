class AirmanshipBadgeModel {
  final String title;
  final List<AirmanshipBadgeItemModel> badges;

  const AirmanshipBadgeModel({
    required this.title,
    required this.badges,
  });

  factory AirmanshipBadgeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AirmanshipBadgeModel(
      title: json['title'] ?? '',
      badges: (json['badges'] as List? ?? [])
          .map(
            (item) => AirmanshipBadgeItemModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'badges': badges.map((item) => item.toJson()).toList(),
    };
  }
}

class AirmanshipBadgeItemModel {
  final String title;
  final String icon;

  const AirmanshipBadgeItemModel({
    required this.title,
    required this.icon,
  });

  factory AirmanshipBadgeItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AirmanshipBadgeItemModel(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
    };
  }
}