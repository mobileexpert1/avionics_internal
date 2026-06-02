import 'dart:ui';

class ReusableWinRuleProgressModel {
  final double progress;
  final String title;
  final String highlightedText;
  final String normalText;
  final VoidCallback? onTap;
  const ReusableWinRuleProgressModel({
    required this.progress,
    required this.title,
    required this.highlightedText,
    required this.normalText,
    this.onTap,
  });
}

class ReusableHelpCardModel {
  final String iconName;
  final String normalText;
  final String highlightedText;
  final String description;
  final VoidCallback? onTap;

  const ReusableHelpCardModel({
    required this.iconName,
    required this.normalText,
    required this.highlightedText,
    required this.description,
    this.onTap,
  });
}

class ReusableGameInfoItemModel {
  final String iconName;
  final String title;
  final String value;
  final String? subtitle;

  const ReusableGameInfoItemModel({
    required this.iconName,
    required this.title,
    required this.value,
    this.subtitle,
  });
}