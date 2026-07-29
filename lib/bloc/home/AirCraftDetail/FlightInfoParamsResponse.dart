class FlightInfoParamsResponse {
  final String? detail;
  final List<FlightParameter>? data;

  FlightInfoParamsResponse({this.detail, this.data});

  factory FlightInfoParamsResponse.fromJson(Map<String, dynamic> json) {
    return FlightInfoParamsResponse(
      detail: json['detail'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => FlightParameter.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data?.map((e) => e.toJson()).toList()};
  }
}

class FlightParameter {
  final String? id;
  final String? parameter;
  final String? info;

  FlightParameter({this.id, this.parameter, this.info});

  factory FlightParameter.fromJson(Map<String, dynamic> json) {
    return FlightParameter(
      id: json['id'],
      parameter: json['parameter'],
      info: json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'parameter': parameter, 'info': info};
  }
}
