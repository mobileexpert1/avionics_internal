class BadgeModel {
  final String title;
  final String image;
  final int unlockAfterWins;
  final bool isUnlocked;

  BadgeModel({
    required this.title,
    required this.image,
    required this.unlockAfterWins,
    this.isUnlocked = false,
  });
}
