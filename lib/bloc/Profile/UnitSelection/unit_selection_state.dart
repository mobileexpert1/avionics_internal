// unit_selection_state.dart
class UnitSelectionState {
  final String speed;
  final String altitude;
  final String distance;
  final String temperature;

  UnitSelectionState({
    required this.speed,
    required this.altitude,
    required this.distance,
    required this.temperature,
  });

  UnitSelectionState copyWith({
    String? speed,
    String? altitude,
    String? distance,
    String? temperature,
  }) {
    return UnitSelectionState(
      speed: speed ?? this.speed,
      altitude: altitude ?? this.altitude,
      distance: distance ?? this.distance,
      temperature: temperature ?? this.temperature,
    );
  }
}
