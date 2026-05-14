import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

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
  final String text;

  const GameInfoItem({required this.asset, required this.text});
}

class GameInfoModel {
  final String title;
  final String description;
  final Widget imageWidget;

  final List<GameInfoItem> infoItems;

  final bool isTopicWise;
  final bool isCalculation;

  const GameInfoModel({
    required this.title,
    required this.description,
    required this.imageWidget,
    required this.infoItems,
    this.isTopicWise = false,
    this.isCalculation = false,
  });

  static GameInfoModel fetch(String gameId) {
    return GameMapper.games[gameId] ??
        const GameInfoModel(
          title: 'Game Detail',
          description: '',
          imageWidget: SizedBox(),
          infoItems: [],
        );
  }
}

class GameMapper {
  static final Map<String, GameInfoModel> games = {
    'quiz': GameInfoModel(
      title: 'Quiz',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.quizDetail),
        width: kIsWeb ? 80 : 40,
        height: kIsWeb ? 80 : 40,
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '10 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),

    'one_word': GameInfoModel(
      title: 'One Word',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.onewordDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '10 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),
    'black_box': GameInfoModel(
      title: 'Black Box',
      description: 'Analyze real world aviation \n scenarios',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.onewordDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '60 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Review factual clue cards and cockpit data',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Play more,earn more badges'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2/4 points for each correct answer',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for full-case accuracy',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: 'Interpret sequences and identify causal factors',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: 'Includes MCQs, sequencing, and multi-factor analysis',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score ≥80% to achieve Investigator Pass',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Play more cases to unlock new badges and scenarios',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text:
              'You’ll learn Real investigative reasoning, human-factor analysis, and system-failure interpretation—exactly as used in real crash investigations.',
        ),
      ],
      isTopicWise: true,
    ),
    'calculation': GameInfoModel(
      title: 'Calculations',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.calculationDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '10 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),

    'imageBased': GameInfoModel(
      title: 'Planespotter',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.quizDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '10 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),

    'trivia': GameInfoModel(
      title: 'Trivia',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.quizDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '10 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),

    'aircraftEncyclopaedia': GameInfoModel(
      title: 'Aircraft Encyclopaedia',
      description: 'Complete the aviation sentence',
      imageWidget: SvgPicture.asset(
        CommonUi.setSvgImage(AssetsPath.quizDetail),
      ),
      infoItems: [
        GameInfoItem(asset: AssetsPath.clock, text: '40 seconds per question'),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: '20 aviation fill-in-the-blanks',
        ),
        GameInfoItem(asset: AssetsPath.Tik, text: 'Topic wise modules'),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+2 points for correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.Tik,
          text: '+3 points for all correct answers',
        ),
        GameInfoItem(
          asset: AssetsPath.clock,
          text: '+1 point if answered under 20s',
        ),
        GameInfoItem(
          asset: AssetsPath.Trophy,
          text: 'Score 80% or more = 1 win',
        ),
        GameInfoItem(
          asset: AssetsPath.carFollowImage,
          text: 'Need a route to the right answer? Follow Me!',
        ),
      ],
      isTopicWise: true,
    ),
  };
}
