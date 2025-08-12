class CalculationGameModel {
  String detail;
  Result result;

  CalculationGameModel({
    required this.detail,
    required this.result,
  });

  factory CalculationGameModel.fromJson(Map<String, dynamic> json) => CalculationGameModel(
    detail: json["detail"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "detail": detail,
    "result": result.toJson(),
  };
}

class Result {
  List<AltitudeConversionsMixedCalculation> altitudeConversionsMixedCalculations;
  List<AltitudeConversionsMixedCalculation> weightBalanceConversions;
  List<AltitudeConversionsMixedCalculation> distanceRangeConversions;
  List<AltitudeConversionsMixedCalculation> fuelVolumeFlowConversions;
  List<AltitudeConversionsMixedCalculation> pressureWeatherDataConversions;
  List<AltitudeConversionsMixedCalculation> speedTimeCalculations;
  List<AltitudeConversionsMixedCalculation> temperatureConversionsImpact;

  Result({
    required this.altitudeConversionsMixedCalculations,
    required this.weightBalanceConversions,
    required this.distanceRangeConversions,
    required this.fuelVolumeFlowConversions,
    required this.pressureWeatherDataConversions,
    required this.speedTimeCalculations,
    required this.temperatureConversionsImpact,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    altitudeConversionsMixedCalculations: List<AltitudeConversionsMixedCalculation>.from(json["Altitude Conversions & Mixed Calculations"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    weightBalanceConversions: List<AltitudeConversionsMixedCalculation>.from(json["Weight & Balance Conversions"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    distanceRangeConversions: List<AltitudeConversionsMixedCalculation>.from(json["Distance & Range Conversions"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    fuelVolumeFlowConversions: List<AltitudeConversionsMixedCalculation>.from(json["Fuel Volume & Flow Conversions"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    pressureWeatherDataConversions: List<AltitudeConversionsMixedCalculation>.from(json["Pressure & Weather Data Conversions"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    speedTimeCalculations: List<AltitudeConversionsMixedCalculation>.from(json["Speed & Time Calculations"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
    temperatureConversionsImpact: List<AltitudeConversionsMixedCalculation>.from(json["Temperature Conversions & Impact"].map((x) => AltitudeConversionsMixedCalculation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Altitude Conversions & Mixed Calculations": List<dynamic>.from(altitudeConversionsMixedCalculations.map((x) => x.toJson())),
    "Weight & Balance Conversions": List<dynamic>.from(weightBalanceConversions.map((x) => x.toJson())),
    "Distance & Range Conversions": List<dynamic>.from(distanceRangeConversions.map((x) => x.toJson())),
    "Fuel Volume & Flow Conversions": List<dynamic>.from(fuelVolumeFlowConversions.map((x) => x.toJson())),
    "Pressure & Weather Data Conversions": List<dynamic>.from(pressureWeatherDataConversions.map((x) => x.toJson())),
    "Speed & Time Calculations": List<dynamic>.from(speedTimeCalculations.map((x) => x.toJson())),
    "Temperature Conversions & Impact": List<dynamic>.from(temperatureConversionsImpact.map((x) => x.toJson())),
  };
}

class AltitudeConversionsMixedCalculation {
  String question;
  List<Option> options;
  Answer answer;
  String explanation;


  AltitudeConversionsMixedCalculation({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory AltitudeConversionsMixedCalculation.fromJson(Map<String, dynamic> json) => AltitudeConversionsMixedCalculation(
    question: json["question"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    answer: answerValues.map[json["answer"]]!,
    explanation: json["explanation"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "answer": answerValues.reverse[answer],
    "explanation": explanation,
  };
}

enum Answer {
  A,
  B,
  C,
  D
}

final answerValues = EnumValues({
  "A": Answer.A,
  "B": Answer.B,
  "C": Answer.C,
  "D": Answer.D
});

class Option {
  Answer label;
  String value;

  Option({
    required this.label,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    label: answerValues.map[json["label"]]!,
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": answerValues.reverse[label],
    "value": value,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
