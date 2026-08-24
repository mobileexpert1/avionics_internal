class JettingChronicleModel {
  final String detail;
  final ChronicleDataModel? data;

  const JettingChronicleModel({required this.detail, required this.data});

  factory JettingChronicleModel.fromJson(Map<String, dynamic> json) {
    return JettingChronicleModel(
      detail: json['detail'] ?? '',
      data: json['data'] != null
          ? ChronicleDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data?.toJson()};
  }
}

class ChronicleDataModel {
  final String id;
  final String title;
  final String description;

  const ChronicleDataModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ChronicleDataModel.fromJson(Map<String, dynamic> json) {
    return ChronicleDataModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description};
  }
}
