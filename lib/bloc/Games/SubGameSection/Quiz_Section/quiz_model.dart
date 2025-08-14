class quizItem {
  final String title;
  final bool isLocked;
  final int gameNumber;

  quizItem({
    required this.title,
    required this.isLocked,
    required this.gameNumber,
  });

  quizItem copyWith({
    String? title,
    bool? isLocked,
    int? gameNumber,
  }) {
    return quizItem(
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      gameNumber: gameNumber ?? this.gameNumber,
    );
  }
}