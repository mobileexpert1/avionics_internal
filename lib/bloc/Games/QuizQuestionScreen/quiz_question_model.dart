class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;
  final String questionId;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
    required this.questionId,
  });
}