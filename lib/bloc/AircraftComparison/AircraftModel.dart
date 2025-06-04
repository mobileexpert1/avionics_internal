class AircraftModel {
  final String id;
  final String name;
  final String manufacturer;
  final String badge;    // add this
  final String? airline; // optional

  AircraftModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.badge,
    this.airline,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AircraftModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
