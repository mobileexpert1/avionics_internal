class FlightKeyValuesModel {
  final String detail;
  final KeyData data;

  FlightKeyValuesModel({required this.detail, required this.data});

  factory FlightKeyValuesModel.fromJson(Map<String, dynamic> json) {
    return FlightKeyValuesModel(
      detail: json['detail'] as String,
      data: KeyData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.toJson()};
  }
}

class KeyData {
  final String openai;

  KeyData({required this.openai});

  factory KeyData.fromJson(Map<String, dynamic> json) {
    return KeyData(openai: json['openai'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'openai': openai};
  }
}
