class BaseAccessTokenModel {
  final String detail;
  final String access;
  final String refresh;

  BaseAccessTokenModel({
    required this.detail,
    required this.access,
    required this.refresh,
  });

  factory BaseAccessTokenModel.fromJson(Map<String, dynamic> json) {
    return BaseAccessTokenModel(
      detail: json['detail'] ?? '',
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
}

