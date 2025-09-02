class FlightModel {
  final String id;
  final double lat;
  final double lon;

  FlightModel({
    required this.id,
    required this.lat,
    required this.lon,
  });

  static List<FlightModel> fromApiResponse(Map<String, dynamic> json) {
    List<FlightModel> flights = [];

    if (json['data'] != null && json['data'] is List) {
      for (var item in json['data']) {
        final id = item['id']?.toString() ?? "";
        final lat = (item['lat'] ?? 0).toDouble();
        final lon = (item['lon'] ?? 0).toDouble();

        flights.add(FlightModel(id: id, lat: lat, lon: lon));
      }
    }

    return flights;
  }
}
