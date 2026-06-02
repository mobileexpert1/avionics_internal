class AvatarListResponseModel {
  final String? detail;
  final List<AvatarModel> data;

  AvatarListResponseModel({this.detail, required this.data});

  factory AvatarListResponseModel.fromJson(Map<String, dynamic> json) {
    return AvatarListResponseModel(
      detail: json['detail'],
      data: (json['data'] as List<dynamic>)
          .map((e) => AvatarModel.fromJson(e))
          .toList(),
    );
  }
}

class AvatarModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String key;
  final String? selectedIcon;

  AvatarModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.key,
    this.selectedIcon,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      key: json['key'] ?? '',
      selectedIcon: json['logo_2'] ?? '',
    );
  }
}
