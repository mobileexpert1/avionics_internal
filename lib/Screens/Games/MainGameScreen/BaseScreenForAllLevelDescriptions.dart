import 'package:avionics_internal/Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import 'package:avionics_internal/Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import 'package:avionics_internal/Helpers/AppNavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../bloc/Games/SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';
import '../GamesSubScreens/BlackBoxSection/BlackBoxLockScreen.dart';
import '../GamesSubScreens/BlackBoxSection/BlackBoxQuestionScreen.dart';
import '../GamesSubScreens/CalculationSection/CalculationLockScreen.dart';
import '../GamesSubScreens/JettingAroundTheWorld/JettingAroundTheWorldScreen.dart';
import '../GamesSubScreens/OneWordSection/OneWordTopicScreen.dart';
import '../GamesSubScreens/QuizSection/QuizLockScreen.dart';
import '../GamesSubScreens/QuizSection/QuizQuestionScreen.dart';
import 'ReusableGameDetailScreen.dart';

class BaseScreenForAllLevelDescriptions extends StatefulWidget {
  final String gameId;

  const BaseScreenForAllLevelDescriptions({super.key, required this.gameId});

  @override
  State<BaseScreenForAllLevelDescriptions> createState() =>
      _BaseScreenForAllLevelState();
}

class _BaseScreenForAllLevelState
    extends State<BaseScreenForAllLevelDescriptions> {
  late final GameInfoModel gameInfo;

  @override
  void initState() {
    super.initState();
    gameInfo = GameInfoModel.fetch(widget.gameId);
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.oneWordTopicListScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableGameDetailScreen(
      gameInfo: gameInfo,
      buttonText: "Start Game",
      onButtonTap: () {
        if (widget.gameId == "imageBased") return;
        onGameTap(context, widget.gameId);
      },
      onBackTap: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> onGameTap(BuildContext context, String gameId) async {
    switch (gameId) {
      case 'quiz':
        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.quizListButton,
          FirebaseEvents.blackBoxListScreen,
        );

        AppNavigator.push(context, QuizLockScreen(), disableSwipeBack: true);
        break;

      case 'one_word':
        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.oneWordListButton,
          FirebaseEvents.oneWordTopicListScreen,
        );

        AppNavigator.push(
          context,
          OneWordTopicScreen(),
          disableSwipeBack: true,
        );
        break;

      case 'black_box':
        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.quizListButton,
          FirebaseEvents.blackBoxListScreen,
        );

        AppNavigator.push(
          context,
          BlackBoxLockScreen(),
          disableSwipeBack: true,
        );
        break;

      case 'calculation':
        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.calculationsListButton,
          FirebaseEvents.calculationsListScreen,
        );

        AppNavigator.push(
          context,
          CalculationLockScreen(),
          disableSwipeBack: true,
        );
        break;

      case 'imageBased':
        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.imageBasedDetailLockScreen,
          FirebaseEvents.imageBasedLockScreen,
        );

        AppNavigator.push(
          context,
          QuizQuestionScreen(
            sectionId: 0,
            sectionTitle: ConstantStrings.imageBasedTitle,
            gameId: "imageBased",
          ),
          disableSwipeBack: true,
        );
        break;

      case 'trivia':
        await SharedPrefsHelper.clearJettingGames();

        AnalyticsService.instance.buttonPressed(
          FirebaseEvents.quizListButton,
          FirebaseEvents.blackBoxListScreen,
        );

        AppNavigator.push(
          context,
          JettingAroundTheWorldScreen(isComeFromResultScreen: false),
          multiBlocProviders: [
            BlocProvider(create: (_) => JettingTheWorldCubit()),
          ],
          disableSwipeBack: true,
        );

        break;

      case 'aircraftEncyclopaedia':
        AppNavigator.push(
          context,
          BlackBoxScreen(
            gameId: 'aircraftEncyclopaedia',
            summarySetId: "",
            summaryGameNumber: 0,
            isForBlackBox: false,
          ),
          disableSwipeBack: true,
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Screen not available for $gameId')),
        );
    }
  }
}
