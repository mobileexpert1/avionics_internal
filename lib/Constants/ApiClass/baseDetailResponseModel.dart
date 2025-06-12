class BaseDetailResponseModel {
  final String detail;

  BaseDetailResponseModel({required this.detail});

  factory BaseDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseDetailResponseModel(
      detail: json['detail'] ?? '',
    );
  }
}
