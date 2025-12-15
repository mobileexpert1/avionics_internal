class Score {
  final int win;
  final int lose;

  Score({
    required this.win,
    required this.lose,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      win: json['win'] ?? 0,
      lose: json['lose'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'win': win,
      'lose': lose,
    };
  }
}

class CalculationLock {
  final String id;
  final bool isEnableTakeMeasure;
  final bool isEnableFlightMath;
  final bool isEnableGreeNewBlue;
  final bool isEnableMindSeparation;
  final Score takeMeasure;
  final Score flightMath;
  final Score greeNewBlue;
  final Score mindSeparation;

  CalculationLock({
    required this.id,
    required this.isEnableTakeMeasure,
    required this.isEnableFlightMath,
    required this.isEnableGreeNewBlue,
    required this.isEnableMindSeparation,
    required this.takeMeasure,
    required this.flightMath,
    required this.greeNewBlue,
    required this.mindSeparation,
  });

  factory CalculationLock.fromJson(Map<String, dynamic> json) {
    return CalculationLock(
      id: json['id'] ?? '',
      isEnableTakeMeasure: json['is_enable_take_measure'] ?? false,
      isEnableFlightMath: json['is_enable_flight_math'] ?? false,
      isEnableGreeNewBlue: json['is_enable_gree_new_blue'] ?? false,
      isEnableMindSeparation: json['is_enable_mind_separation'] ?? false,
      takeMeasure: Score.fromJson(json['take_measure'] ?? {}),
      flightMath: Score.fromJson(json['flight_math'] ?? {}),
      greeNewBlue: Score.fromJson(json['gree_new_blue'] ?? {}),
      mindSeparation: Score.fromJson(json['mind_separation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_enable_take_measure': isEnableTakeMeasure,
      'is_enable_flight_math': isEnableFlightMath,
      'is_enable_gree_new_blue': isEnableGreeNewBlue,
      'is_enable_mind_separation': isEnableMindSeparation,
      'take_measure': takeMeasure.toJson(),
      'flight_math': flightMath.toJson(),
      'gree_new_blue': greeNewBlue.toJson(),
      'mind_separation': mindSeparation.toJson(),
    };
  }
}
