// Response Model
class MapSearchAircraftListModel {
  final List<FlightResult> results;
  final FlightStats stats;

  MapSearchAircraftListModel({required this.results, required this.stats});

  factory MapSearchAircraftListModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultList = json['results'] ?? [];
    return MapSearchAircraftListModel(
      results: resultList.map((e) => FlightResult.fromJson(e)).toList(),
      stats: FlightStats.fromJson(json['stats'] ?? {}),
    );
  }
}

/// Individual Flight Result
class FlightResult {
  final String id;
  final String label;
  final FlightDetail detail;
  final String type;
  final String match;

  FlightResult({
    required this.id,
    required this.label,
    required this.detail,
    required this.type,
    required this.match,
  });

  factory FlightResult.fromJson(Map<String, dynamic> json) {
    return FlightResult(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      detail: FlightDetail.fromJson(json['detail'] ?? {}),
      type: json['type'] ?? '',
      match: json['match'] ?? '',
    );
  }
}

/// Flight Details
class FlightDetail {
  final double lat;
  final double lon;
  final String schdFrom;
  final String schdTo;
  final String acType;
  final String route;
  final String logo;
  final String reg;
  final String callsign;
  final String flight;
  final String operator;
  final int operatorId;

  FlightDetail({
    required this.lat,
    required this.lon,
    required this.schdFrom,
    required this.schdTo,
    required this.acType,
    required this.route,
    required this.logo,
    required this.reg,
    required this.callsign,
    required this.flight,
    required this.operator,
    required this.operatorId,
  });

  factory FlightDetail.fromJson(Map<String, dynamic> json) {
    return FlightDetail(
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      schdFrom: json['schd_from'] ?? '',
      schdTo: json['schd_to'] ?? '',
      acType: json['ac_type'] ?? '',
      route: json['route'] ?? '',
      logo: json['logo'] ?? '',
      reg: json['reg'] ?? '',
      callsign: json['callsign'] ?? '',
      flight: json['flight'] ?? '',
      operator: json['operator'] ?? '',
      operatorId: json['operator_id'] ?? 0,
    );
  }
}

/// Stats section
class FlightStats {
  final int total;
  final int count;

  FlightStats({required this.total, required this.count});

  factory FlightStats.fromJson(Map<String, dynamic> json) {
    return FlightStats(total: json['total'] ?? 0, count: json['count'] ?? 0);
  }
}
