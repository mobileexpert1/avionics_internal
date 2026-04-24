import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizLockScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

class QuizDetailScreen extends StatefulWidget {
  final String gameId;

  const QuizDetailScreen({super.key, required this.gameId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.quizListScreen);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb;

    return BlocProvider(
      create: (_) => GameDetailCubit(
        GameInfo(
          title: 'Quiz',
          description: 'Complete the aviation sentence',
          questions: 10,
          questionType: 'aviation fill-in-the-blanks',
          moduleType: 'Topic wise modules',
          iconWidget: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.quizDetail),
            width: isWeb ? 80 : 40,
            height: isWeb ? 80 : 40,
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Quiz',
          centerTitle: false,
          leftButton: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: isWeb ? 28 : 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 1500 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.all(isWeb ? screenWidth * 0.02 : 16),
              child: GameDetailCard(
                onStartGame: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizLockScreen()),
                  );
                  AnalyticsService.instance.buttonPressed(
                    FirebaseEvents.quizListButton,
                    FirebaseEvents.blackBoxListScreen,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
