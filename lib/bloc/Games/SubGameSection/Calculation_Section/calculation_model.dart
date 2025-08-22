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

