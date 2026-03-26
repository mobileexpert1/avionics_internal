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

  ApiErrorDetail({required this.loc, required this.msg, required this.type});

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) {
    return ApiErrorDetail(
      loc: json['loc'] ?? [],
      msg: json['msg'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

String mapStatusCode(dynamic error) {
  final errorString = error.toString();

  if (errorString.contains("400")) {
    return "Invalid request. Please try again.";
  }

  if (errorString.contains("401")) {
    return "Invalid email or password.";
  }

  if (errorString.contains("422")) {
    return "Validation failed. Please check your input.";
  }

  if (errorString.contains("500") ||
      errorString.contains("502") ||
      errorString.contains("503")) {
    return "Server is currently unavailable. Please try again later.";
  }

  if (errorString.contains("504")) {
    return "Server is taking too long to respond.";
  }

  if (errorString.contains("SocketException")) {
    return "No internet connection.";
  }

  if (errorString.contains("TimeoutException")) {
    return "Connection timed out. Please try again.";
  }

  return errorString;
}
