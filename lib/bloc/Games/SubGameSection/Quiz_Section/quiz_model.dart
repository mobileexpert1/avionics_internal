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

String getAssetImageForBasic(int gameNumber) {
  switch (gameNumber) {
    case 1:
      return AssetsPath.aeroplaneBasic;
    case 2:
      return AssetsPath.settingBasic;
    case 3:
      return AssetsPath.trackBasic;
    case 4:
      return AssetsPath.aeroplaneClouds;
    case 5:
      return AssetsPath.notesBasic;
    default:
      return AssetsPath.userBasic;
  }
}

String getConstantDescriptionForBasic(int gameNumber) {
  switch (gameNumber) {
    case 1:
      return "Master the fundamentals of how aircraft fly";
    case 2:
      return "Explore aircraft instruments and onboard systems";
    case 3:
      return "Understand airspace rules and flight procedures";
    case 4:
      return "Learn how weather impacts aviation";
    case 5:
      return "Learn aviation rules, compliance, and legal standards";
    default:
      return "Study pilot behavior, decision-making, and safety practices";
  }
}
