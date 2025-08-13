class CalculationLock {
  final String id;
  final bool isEnableTakeMeasure;
  final bool isEnableFlightMath;
  final bool isEnableGreeNewBlue;
  final bool isEnableMindSeparation;

  CalculationLock({
    required this.id,
    required this.isEnableTakeMeasure,
    required this.isEnableFlightMath,
    required this.isEnableGreeNewBlue,
    required this.isEnableMindSeparation,
  });

  factory CalculationLock.fromJson(Map<String, dynamic> json) {
    return CalculationLock(
      id: json['id'] ?? '',
      isEnableTakeMeasure: json['is_enable_take_measure'] ?? false,
      isEnableFlightMath: json['is_enable_flight_math'] ?? false,
      isEnableGreeNewBlue: json['is_enable_gree_new_blue'] ?? false,
      isEnableMindSeparation: json['is_enable_mind_separation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_enable_take_measure': isEnableTakeMeasure,
      'is_enable_flight_math': isEnableFlightMath,
      'is_enable_gree_new_blue': isEnableGreeNewBlue,
      'is_enable_mind_separation': isEnableMindSeparation,
    };
  }
}
