import '../../../Database/db_helper.dart';

class UnitOption extends BaseModel {
  @override
  final String id;
  final String unit;
  final bool isSelected;

  UnitOption({
    required this.unit,
    required this.isSelected,
  }) : id = unit;

  UnitOption.withId({
    required this.id,
    required this.unit,
    required this.isSelected,
  });
  factory UnitOption.fromJson(Map<String, dynamic> json) => UnitOption(
    unit: json['unit'],
    isSelected: _toBool(json['is_selected']),
  );

  factory UnitOption.fromMap(Map<String, dynamic> map) => UnitOption.withId(
    id: map['id'],
    unit: map['unit'],
    isSelected: _toBool(map['is_selected']),
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'unit': unit,
    'is_selected': isSelected ? 1 : 0,
  };

  @override
  String get table => 'unit_prefs';

  static bool _toBool(Object? v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
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
    final prefs = json['preferences'] as Map<String, dynamic>? ?? {};

    List<UnitOption> _parse(String key) =>
        (prefs[key] as List<dynamic>? ?? [])
            .map((e) => UnitOption.fromJson(e as Map<String, dynamic>))
            .toList();

    return UnitSelectionModel(
      speed: _parse('speed'),
      altitude: _parse('altitude'),
      distance: _parse('distance'),
      temperature: _parse('temperature'),
    );
  }

  factory UnitSelectionModel.fromPrefs(List<UnitOption> all) {
    List<UnitOption> _pick(String category) =>
        all.where((u) => u.id.startsWith(category)).toList();

    return UnitSelectionModel(
      speed: _pick('speed'),
      altitude: _pick('altitude'),
      distance: _pick('distance'),
      temperature: _pick('temperature'),
    );
  }
}


class UnitItem {
  final String unit;
  final bool isSelected;

  UnitItem({required this.unit, required this.isSelected});

  factory UnitItem.fromJson(Map<String, dynamic> json) => UnitItem(
    unit: json['unit'] as String? ?? '',
    isSelected: UnitOption._toBool(json['is_selected']),
  );

  factory UnitItem.fromOption(UnitOption o) =>
      UnitItem(unit: o.unit, isSelected: o.isSelected);
}
