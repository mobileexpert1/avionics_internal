class UnitOption {
  final String unit;
  final bool isSelected;

  UnitOption({required this.unit, required this.isSelected});

  factory UnitOption.fromJson(Map<String, dynamic> json) {
    return UnitOption(
      unit: json['unit'],
      isSelected: json['is_selected'],
    );
  }
}

class UnitSelectionModel {
  final List<UnitOption> speed;
  final List<UnitOption> altitude;
  final List<UnitOption> distance;
  final List<UnitOption> temperature;

  UnitSelectionModel({
    required this.speed,
    required this.altitude,
    required this.distance,
    required this.temperature,
  });

  factory UnitSelectionModel.fromJson(Map<String, dynamic> json) {
    final prefs = json['preferences'];

    return UnitSelectionModel(
      speed: (prefs['speed'] as List)
          .map((item) => UnitOption.fromJson(item))
          .toList(),
      altitude: (prefs['altitude'] as List)
          .map((item) => UnitOption.fromJson(item))
          .toList(),
      distance: (prefs['distance'] as List)
          .map((item) => UnitOption.fromJson(item))
          .toList(),
      temperature: (prefs['temperature'] as List)
          .map((item) => UnitOption.fromJson(item))
          .toList(),
    );
  }
}


class UnitItem {
  final String unit;
  final bool isSelected;

  UnitItem({required this.unit, required this.isSelected});

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      unit: json['unit'],
      isSelected: json['is_selected'],
    );
  }
}
