// class CalculationGameModel {
//   String detail;
//   Result result;
//
//   CalculationGameModel({required this.detail, required this.result});
//
//   factory CalculationGameModel.fromJson(Map<String, dynamic> json) =>
//       CalculationGameModel(
//         detail: json["detail"],
//         result: Result.fromJson(json["result"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//     "detail": detail,
//     "result": result.toJson(),
//   };
// }
//
// class Result {
//   List<AltitudeConversionsMixedCalculation>
//   altitudeConversionsMixedCalculations;
//   List<AltitudeConversionsMixedCalculation> weightBalanceConversions;
//   List<AltitudeConversionsMixedCalculation> distanceRangeConversions;
//   List<AltitudeConversionsMixedCalculation> fuelVolumeFlowConversions;
//   List<AltitudeConversionsMixedCalculation> pressureWeatherDataConversions;
//   List<AltitudeConversionsMixedCalculation> speedTimeCalculations;
//   List<AltitudeConversionsMixedCalculation> temperatureConversionsImpact;
//
//   Result({
//     required this.altitudeConversionsMixedCalculations,
//     required this.weightBalanceConversions,
//     required this.distanceRangeConversions,
//     required this.fuelVolumeFlowConversions,
//     required this.pressureWeatherDataConversions,
//     required this.speedTimeCalculations,
//     required this.temperatureConversionsImpact,
//   });
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     altitudeConversionsMixedCalculations:
//         List<AltitudeConversionsMixedCalculation>.from(
//           json["altitude_conversions"].map(
//             (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//           ),
//         ),
//     weightBalanceConversions: List<AltitudeConversionsMixedCalculation>.from(
//       json["weight_conversions"].map(
//         (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//       ),
//     ),
//     distanceRangeConversions: List<AltitudeConversionsMixedCalculation>.from(
//       json["distance_conversions"].map(
//         (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//       ),
//     ),
//     fuelVolumeFlowConversions: List<AltitudeConversionsMixedCalculation>.from(
//       json["fuel_volume_conversions"].map(
//         (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//       ),
//     ),
//     pressureWeatherDataConversions:
//         List<AltitudeConversionsMixedCalculation>.from(
//           json["pressure_conversions"].map(
//             (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//           ),
//         ),
//     speedTimeCalculations: List<AltitudeConversionsMixedCalculation>.from(
//       json["speed_conversions"].map(
//         (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//       ),
//     ),
//     temperatureConversionsImpact:
//         List<AltitudeConversionsMixedCalculation>.from(
//           json["temperature_conversions"].map(
//             (x) => AltitudeConversionsMixedCalculation.fromJson(x),
//           ),
//         ),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "altitude_conversions": List<dynamic>.from(
//       altitudeConversionsMixedCalculations.map((x) => x.toJson()),
//     ),
//     "weight_conversions": List<dynamic>.from(
//       weightBalanceConversions.map((x) => x.toJson()),
//     ),
//     "distance_conversions": List<dynamic>.from(
//       distanceRangeConversions.map((x) => x.toJson()),
//     ),
//     "fuel_volume_conversions": List<dynamic>.from(
//       fuelVolumeFlowConversions.map((x) => x.toJson()),
//     ),
//     "pressure_conversions": List<dynamic>.from(
//       pressureWeatherDataConversions.map((x) => x.toJson()),
//     ),
//     "speed_conversions": List<dynamic>.from(
//       speedTimeCalculations.map((x) => x.toJson()),
//     ),
//     "temperature_conversions": List<dynamic>.from(
//       temperatureConversionsImpact.map((x) => x.toJson()),
//     ),
//   };
// }
//
// class AltitudeConversionsMixedCalculation {
//   String question;
//   List<Option> options;
//   Answer answer;
//   String explanation;
//
//   AltitudeConversionsMixedCalculation({
//     required this.question,
//     required this.options,
//     required this.answer,
//     required this.explanation,
//   });
//
//   factory AltitudeConversionsMixedCalculation.fromJson(
//     Map<String, dynamic> json,
//   ) => AltitudeConversionsMixedCalculation(
//     question: json["question"],
//     options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
//     answer: answerValues.map[json["answer"]]!,
//     explanation: json["explanation"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "question": question,
//     "options": List<dynamic>.from(options.map((x) => x.toJson())),
//     "answer": answerValues.reverse[answer],
//     "explanation": explanation,
//   };
// }
//
// enum Answer { A, B, C, D }
//
// final answerValues = EnumValues({
//   "A": Answer.A,
//   "B": Answer.B,
//   "C": Answer.C,
//   "D": Answer.D,
// });
//
// class Option {
//   Answer label;
//   String value;
//
//   Option({required this.label, required this.value});
//
//   factory Option.fromJson(Map<String, dynamic> json) =>
//       Option(label: answerValues.map[json["label"]]!, value: json["value"]);
//
//   Map<String, dynamic> toJson() => {
//     "label": answerValues.reverse[label],
//     "value": value,
//   };
// }
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }





class CalculationGameModel {
  final String game;
  final String level;
  final String difficulty;
  final List<CategoryType> categoryTypes;

  CalculationGameModel({
    required this.game,
    required this.level,
    required this.difficulty,
    required this.categoryTypes,
  });

  factory CalculationGameModel.fromJson(Map<String, dynamic> json) {
    return CalculationGameModel(
      game: json["game"] ?? "",
      level: json["level"] ?? "",
      difficulty: json["difficulty"] ?? "",
      categoryTypes: json["category_types"] == null
          ? []
          : List<CategoryType>.from(
        json["category_types"].map((x) => CategoryType.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "game": game,
    "level": level,
    "difficulty": difficulty,
    "category_types": List<dynamic>.from(
      categoryTypes.map((x) => x.toJson()),
    ),
  };
}

class CategoryType {
  final String type;
  final String name;
  final List<Question> questions;

  CategoryType({
    required this.type,
    required this.name,
    required this.questions,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      type: json["type"] ?? "",
      name: json["name"] ?? "",
      questions: json["questions"] == null
          ? []
          : List<Question>.from(
        json["questions"].map((x) => Question.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "name": name,
    "questions": List<dynamic>.from(
      questions.map((x) => x.toJson()),
    ),
  };
}

class Question {
  final String question;
  final List<Option> options;
  final String answer;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json["question"] ?? "",
      options: json["options"] == null
          ? []
          : List<Option>.from(
        json["options"].map((x) => Option.fromJson(x)),
      ),
      answer: json["answer"] ?? "",
      explanation: json["explanation"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "question": question,
    "options": List<dynamic>.from(
      options.map((x) => x.toJson()),
    ),
    "answer": answer,
    "explanation": explanation,
  };
}

class Option {
  final String label;
  final String value;

  Option({
    required this.label,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      label: json["label"] ?? "",
      value: json["value"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "label": label,
    "value": value,
  };
}
