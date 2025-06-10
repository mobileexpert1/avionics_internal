
enum CommonApiStatus { initial, submitting, success, failure }

class ApiErrorModel {
  final List<ApiErrorDetail> detail;

  ApiErrorModel({required this.detail});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      detail: (json['detail'] as List<dynamic>)
          .map((e) => ApiErrorDetail.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return detail.map((e) => e.msg).join('\n');
  }
}

class ApiErrorDetail {
  final List<dynamic> loc;
  final String msg;
  final String type;

  ApiErrorDetail({
    required this.loc,
    required this.msg,
    required this.type,
  });

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) {
    return ApiErrorDetail(
      loc: json['loc'] ?? [],
      msg: json['msg'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
