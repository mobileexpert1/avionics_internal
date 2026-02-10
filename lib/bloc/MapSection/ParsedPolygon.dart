import 'dart:convert';

class ParsedPolygon {
  final String id;
  final String name;
  final List<List<List<double>>> polygons;

  ParsedPolygon({required this.id, required this.name, required this.polygons});
}

List<ParsedPolygon> parseGeoJson(String jsonStr) {
  final Map<String, dynamic> data = jsonDecode(jsonStr);
  final List features = data['features'];

  int id = 1;
  final List<ParsedPolygon> result = [];

  for (final feature in features) {
    final geometry = feature['geometry'];
    final String type = geometry['type'];
    final String name = feature['properties']?['name'] ?? 'Unknown FIR';

    final List<List<List<double>>> polygons = [];

    if (type == 'Polygon') {
      // Polygon → coordinates: [ [ [lng, lat], ... ] ]
      final List rings = geometry['coordinates'];

      final List<List<double>> outerRing = [];
      for (final coord in rings[0]) {
        outerRing.add([
          (coord[0] as num).toDouble(), // lng
          (coord[1] as num).toDouble(), // lat
        ]);
      }

      polygons.add(outerRing);
    } else if (type == 'MultiPolygon') {
      // MultiPolygon → [ [ [ [lng, lat] ] ], ... ]
      final List multi = geometry['coordinates'];

      for (final polygon in multi) {
        final List<List<double>> outerRing = [];

        for (final coord in polygon[0]) {
          outerRing.add([
            (coord[0] as num).toDouble(), // lng
            (coord[1] as num).toDouble(), // lat
          ]);
        }

        polygons.add(outerRing);
      }
    } else {
      continue; // Ignore unsupported geometry
    }

    result.add(ParsedPolygon(id: 'fir_$id', name: name, polygons: polygons));

    id++;
  }

  return result;
}
