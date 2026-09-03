import 'package:flutter/cupertino.dart';
import '../../../../Constants/constantImages.dart';

class GameInfo {
  final String title;
  final String description;
  final int questions;
  final String questionType;
  final String moduleType;
  final Widget iconWidget;
  final bool isTopicWise;
  final bool isCalculation;

  const GameInfo({
    required this.title,
    required this.description,
    required this.questions,
    required this.questionType,
    required this.moduleType,
    required this.iconWidget,
    this.isTopicWise = false,
    this.isCalculation = false,
  });
}

class GameInfoItem {
  final String asset;
  final String title;
  final String value;
  final String? subtitle;

  const GameInfoItem({
    required this.asset,
    required this.title,
    required this.value,
    this.subtitle,
  });
}

class GameInfoModel {
  final String title;
  final String description;
  final List<GameInfoItem> infoItems;
  final double progress;
  final String winTitle;
  final String winHighlightedText;
  final String winNormalText;
  final String? helpTitle;
  final String? helpHighlightedTitle;
  final String? helpDescription;

  const GameInfoModel({
    required this.title,
    required this.description,
    required this.infoItems,
    this.progress = 0.00,
    this.winTitle = '',
    this.winHighlightedText = '',
    this.winNormalText = '',
    this.helpTitle,
    this.helpHighlightedTitle,
    this.helpDescription,
  });

  static GameInfoModel fetch(String gameId) {
    return GameMapper.games[gameId] ??
        const GameInfoModel(
          title: 'Game Detail',
          description: '',
          infoItems: [],
        );
  }
}

class GameMapper {
  static final Map<String, GameInfoModel> games = {
    'quiz': GameInfoModel(
      title: 'Aviation Quiz',
      description: 'Complete the aviation sentence',
      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '40 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '20 questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Topic wise modules',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.90,
      winTitle: 'Score target to win',
      winHighlightedText: '90%',
      winNormalText: ' or higher',
      helpTitle: 'Need a route to the right answer? ',
      helpHighlightedTitle: 'Follow Me!',
      helpDescription: 'Stay on course and reach the correct answer faster.',
    ), // Done
    'one_word': GameInfoModel(
      title: 'Basic Topics',

      description: 'Complete the aviation sentence',

      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '40 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '10 questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Fill in the blanks',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],
      progress: 0.70,
      winTitle: 'Score target to win',
      winHighlightedText: '70%',
      winNormalText: ' or higher',
      helpTitle: 'Need a navigation assist? ',
      helpHighlightedTitle: 'Follow me car!',
      helpDescription: 'Stay on course and reach the correct answer faster.',
    ),
    'black_box': GameInfoModel(
      title: 'Black Box',

      description: 'Analyze real world aviation scenarios',

      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '60 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: 'Review factual clue cards and cockpit data',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Questions Type',
          value: 'Includes MCQs, sequencing, and multi-factor analysis',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.60,
      winTitle: 'Investigator Pass',
      winHighlightedText: '60%',
      winNormalText: ' or higher',
      helpTitle: 'Need a route to the right answer? ',
      helpHighlightedTitle: 'Follow Me!',
      helpDescription:
      'Learn real investigative reasoning and system-failure interpretation.',
    ), // Done
    'calculation': GameInfoModel(
      title: 'Calculations',
      description: 'Complete the aviation sentence',
      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '40 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '10 calculation questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Numerical aviation calculations',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.50,

      winTitle: 'Score target to win',

      winHighlightedText: '50%',

      winNormalText: ' or higher',

      helpTitle: 'Need help solving faster? ',

      helpHighlightedTitle: 'Follow Me!',

      helpDescription: 'Improve your aviation calculation speed and accuracy.',
    ), // Done
    'imageBased': GameInfoModel(
      title: 'PlaneSpotter',
      description: 'Complete the aviation sentence',
      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '60 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '10 aircraft image questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Topic wise modules',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.60,
      winTitle: 'Score target to win',
      winHighlightedText: '60%',
      winNormalText: ' or higher',
      helpTitle: 'Need aircraft recognition help? ',
      helpHighlightedTitle: 'Follow Me!',
      helpDescription: 'Learn aircraft spotting and identification techniques.',
    ), //Done
    'trivia': GameInfoModel(
      title: 'Jetting Around The World',
      description: 'Complete the aviation sentence',

      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '40 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '10 trivia questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Topic wise modules',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.35,

      winTitle: 'Score target to win',

      winHighlightedText: '35%',

      winNormalText: ' or higher',

      helpTitle: 'Need help with trivia? ',

      helpHighlightedTitle: 'Follow Me!',

      helpDescription: 'Boost your aviation knowledge with guided hints.',
    ), //Done
    'aircraftEncyclopaedia': GameInfoModel(
      title: 'Citius. Altius. Longius.',
      description: 'Complete the aviation sentence',

      infoItems: [
        GameInfoItem(
          asset: AssetsPath.timeLevelIcon,
          title: 'Time per question',
          value: '40 seconds',
        ),

        GameInfoItem(
          asset: AssetsPath.questionLevelIcon,
          title: 'Questions',
          value: '20 Questions',
        ),

        GameInfoItem(
          asset: AssetsPath.aeroplaneLevelIcon,
          title: 'Question type',
          value: 'Topic wise modules',
        ),

        GameInfoItem(
          asset: AssetsPath.correctLevelAnswer,
          title: 'Correct answer',
          value: '+2 points',
        ),

        GameInfoItem(
          asset: AssetsPath.speedLevelBounce,
          title: 'Speed bonus',
          value: '+1 point',
          subtitle: 'If answered under 20 sec',
        ),

        GameInfoItem(
          asset: AssetsPath.perfectLevelBounce,
          title: 'Perfect bonus',
          value: '+3 points',
          subtitle: 'For all correct answers',
        ),
      ],

      progress: 0.80,
      winTitle: 'Score target to win',
      winHighlightedText: '80%',
      winNormalText: ' or higher',
      helpTitle: 'Need aircraft guidance? ',
      helpHighlightedTitle: 'Follow Me!',
      helpDescription:
      'Understand aircraft systems and aviation history faster.',
    ), // Done
  };
}
