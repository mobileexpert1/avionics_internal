class GameResultState {
  final String title;
  final int score;
  final int total;
  final int totalPoints;
  final int correctPoints;
  final List<String> bonusPoints;
  final String? badgeText;

  const GameResultState({
    required this.title,
    required this.score,
    required this.total,
    required this.totalPoints,
    required this.correctPoints,
    required this.bonusPoints,
    this.badgeText,
  });

  factory GameResultState.initial() {
    return const GameResultState(
      title: '',
      score: 0,
      total: 0,
      totalPoints: 0,
      correctPoints: 0,
      bonusPoints: [],
      badgeText: null,
    );
  }
}
