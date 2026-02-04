import 'dart:convert';

class ParsedPolygon {
  final String id;
  final List<List<double>> points;
  final String name;

  ParsedPolygon(this.id, this.points, this.name);
}

List<ParsedPolygon> parseGeoJson(String jsonStr) {
  final Map<String, dynamic> data = jsonDecode(jsonStr);
  final List features = data['features'];

  int id = 1;
  final List<ParsedPolygon> result = [];

  for (final feature in features) {
    final geometry = feature['geometry'];
    if (geometry['type'] != 'Polygon') continue;

    final List rings = geometry['coordinates'];
    final List<List<double>> points = [];

    for (final coord in rings[0]) {
      points.add([(coord[1] as num).toDouble(), (coord[0] as num).toDouble()]);
    }

    result.add(
      ParsedPolygon(
        'fir_$id',
        points,
        feature['properties']['name'] ?? 'Unknown FIR',
      ),
    );
    id++;
  }

  return result;
}
