class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;
  final String imgUrl;
  final String questionId;
  final String setId;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
    required this.imgUrl,
    required this.questionId,
    required this.setId,
  });
}