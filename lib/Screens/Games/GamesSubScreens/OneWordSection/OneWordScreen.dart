import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/OneWordSection/OneWordTopicScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

class OneWordDetailScreen extends StatefulWidget {
  final String gameId;

  const OneWordDetailScreen({super.key, required this.gameId});

  @override
  State<OneWordDetailScreen> createState() => _OneWordDetailScreenState();
}

class _OneWordDetailScreenState extends State<OneWordDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.oneWordTopicListScreen,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameDetailCubit(
        GameInfo(
          title: 'One Word',
          description: 'Complete the aviation sentence',
          questions: 10,
          questionType: 'aviation fill-in-the-blanks',
          moduleType: 'Topic wise modules',
          iconWidget: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.onewordDetail),
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'One word game',
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GameDetailCard(
                onStartGame: () {
                  AppNavigator.push(
                    context,
                    OneWordTopicScreen(),
                    disableSwipeBack: true,
                  );
                  AnalyticsService.instance.buttonPressed(
                    FirebaseEvents.oneWordListButton,
                    FirebaseEvents.oneWordTopicListScreen,
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
