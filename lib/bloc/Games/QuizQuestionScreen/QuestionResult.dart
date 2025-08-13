class QuestionResult {
  final int? userAnswerIndex;
  final int correctPoint;
  final int bonusPoint;
  final int timeTakenSeconds;

  QuestionResult({
    required this.userAnswerIndex,
    required this.correctPoint,
    required this.bonusPoint,
    required this.timeTakenSeconds,
  });

  Map<String, dynamic> toJson() => {
    'userAnswerIndex': userAnswerIndex,
    'correctPoint': correctPoint,
    'bonusPoint': bonusPoint,
    'timeTakenSeconds': timeTakenSeconds,
  };
}

