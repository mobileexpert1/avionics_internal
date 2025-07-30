class quizItem {
  final String title;
  final bool isLocked;

  quizItem({required this.title, required this.isLocked});

  quizItem copyWith({String? title, bool? isLocked}) {
    return quizItem(
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
