import '../../../../Constants/constantImages.dart';

class QuizPerItem {
  final String title;
  final bool isLocked;
  final int gameNumber;
  final List<String> info;

  QuizPerItem({
    required this.title,
    required this.isLocked,
    required this.gameNumber,
    required this.info,
  });

  QuizPerItem copyWith({
    String? title,
    bool? isLocked,
    int? gameNumber,
    List<String>? info,
  }) {
    return QuizPerItem(
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      gameNumber: gameNumber ?? this.gameNumber,
      info: info ?? this.info,
    );
  }
}