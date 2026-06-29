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
  final String? fr24;
  final String? googleMapsKey;

  KeyData({this.fr24, this.googleMapsKey});

  factory KeyData.fromJson(Map<String, dynamic> json) {
    return KeyData(
      fr24:
          json['avioflai/fr24'] != null &&
              json['avioflai/fr24'] is String &&
              (json['avioflai/fr24'] as String).isNotEmpty
          ? json['avioflai/fr24'] as String
          : null,
      googleMapsKey:
          json['avioflai-google-maps'] != null &&
              json['avioflai-google-maps'] is String &&
              (json['avioflai-google-maps'] as String).isNotEmpty
          ? json['avioflai-google-maps'] as String
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fr24 != null) 'fr24': fr24,
      if (googleMapsKey != null) 'avioflai-google-maps': googleMapsKey,
    };
  }
}
