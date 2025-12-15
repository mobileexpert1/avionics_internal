class QuestionResult {
  final int? userAnswerIndex;
  final int correctPoint;
  final int bonusPoint;
  final int timeTakenSeconds;

  // These extra fields help build API payloads without needing to manually combine later
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;

  QuestionResult({
    required this.userAnswerIndex,
    required this.correctPoint,
    required this.bonusPoint,
    required this.timeTakenSeconds,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
  });

  Map<String, dynamic> toJson() {
    String indexToLetter(int? index) {
      if (index == null) return "";
      return String.fromCharCode(65 + index); // A=0, B=1, etc.
    }

    return {
      "question": question,
      "options": List.generate(options.length, (optIndex) {
        return {
          "label": String.fromCharCode(65 + optIndex),
          "value": options[optIndex],
        };
      }),
      "answer": indexToLetter(correctIndex),
      "explanation": hint,
      "user_answered": indexToLetter(userAnswerIndex),
      "correct_point": correctPoint,
      "bonus_point": bonusPoint,
      "time_taken": timeTakenSeconds,
    };
  }
}
