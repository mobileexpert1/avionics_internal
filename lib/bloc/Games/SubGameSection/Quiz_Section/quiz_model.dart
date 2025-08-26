class quizItem {
  final String title;
  final bool isLocked;
  final int gameNumber;
  final List<String> info;

  quizItem({
    required this.title,
    required this.isLocked,
    required this.gameNumber,
    required this.info,
  });

  quizItem copyWith({
    String? title,
    bool? isLocked,
    int? gameNumber,
    List<String>? info,
  }) {
    return quizItem(
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      gameNumber: gameNumber ?? this.gameNumber,
      info: info ?? this.info,
    );
  }
}