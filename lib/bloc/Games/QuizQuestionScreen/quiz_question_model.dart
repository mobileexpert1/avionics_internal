class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
  });
}