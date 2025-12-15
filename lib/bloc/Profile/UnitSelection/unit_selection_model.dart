import '../../../Database/db_helper.dart';

class UnitOption extends BaseModel {
  @override
  final String id;
  @override
  String? userId;

  final String unit;
  final bool   isSelected;

  UnitOption({
    required this.unit,
    required this.isSelected,
    this.userId,
  }) : id = unit;

  UnitOption.withId({
    required this.id,
    required this.unit,
    required this.isSelected,
    this.userId,
  });

  factory UnitOption.fromJson(Map<String, dynamic> json) => UnitOption(
    unit       : json['unit'],
    isSelected : _toBool(json['is_selected']),
    userId     : json['user_id'],
  );

  factory UnitOption.fromMap(Map<String, dynamic> m) => UnitOption.withId(
    id         : m['id'],
    unit       : m['unit'],
    isSelected : _toBool(m['is_selected']),
    userId     : m['user_id'],
  );

  @override
  Map<String, dynamic> toMap() => {
    'id'        : id,
    'unit'      : unit,
    'is_selected': isSelected ? 1 : 0,
    'user_id'   : userId,
  };

  @override
  String get table => 'unit_prefs';

  static bool _toBool(Object? v) {
    if (v is bool) return v;
    if (v is int)  return v == 1;
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
      speed       : _parse('speed'),
      altitude    : _parse('altitude'),
      distance    : _parse('distance'),
      temperature : _parse('temperature'),
    );
  }

  factory UnitSelectionModel.fromPrefs(List<UnitOption> all) {
    List<UnitOption> _pick(String cat) =>
        all.where((u) => u.id.startsWith(cat)).toList();

    return UnitSelectionModel(
      speed       : _pick('speed'),
      altitude    : _pick('altitude'),
      distance    : _pick('distance'),
      temperature : _pick('temperature'),
    );
  }
}


class UnitItem {
  final String unit;
  final bool   isSelected;

  UnitItem({required this.unit, required this.isSelected});

  factory UnitItem.fromJson(Map<String, dynamic> json) => UnitItem(
    unit       : json['unit'] as String? ?? '',
    isSelected : UnitOption._toBool(json['is_selected']),
  );

  factory UnitItem.fromOption(UnitOption o) =>
      UnitItem(unit: o.unit, isSelected: o.isSelected);
}
