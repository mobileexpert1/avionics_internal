// class QuizQuestion {
//   final String question;
//   final List<String> options;
//   final int correctIndex;
//   final String hint;
//
//   QuizQuestion({
//     required this.question,
//     required this.options,
//     required this.correctIndex,
//     required this.hint,
//   });
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is QuizQuestion &&
//               runtimeType == other.runtimeType &&
//               question == other.question &&
//               options.toString() == other.options.toString() &&
//               correctIndex == other.correctIndex &&
//               hint == other.hint;
//
//   @override
//   int get hashCode =>
//       question.hashCode ^
//       options.toString().hashCode ^
//       correctIndex.hashCode ^
//       (hint?.hashCode ?? 0);
// }
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