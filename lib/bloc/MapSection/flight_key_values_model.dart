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
  final String fr24;

  KeyData({required this.fr24});

  factory KeyData.fromJson(Map<String, dynamic> json) {
    return KeyData(fr24: json['fr24'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'fr24': fr24};
  }
}
