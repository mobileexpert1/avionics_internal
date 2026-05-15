import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/BlackBoxSection/BlackBoxLockScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

class BlackBoxStartScreen extends StatefulWidget {
  final String gameId;

  const BlackBoxStartScreen({super.key, required this.gameId});

  @override
  State<BlackBoxStartScreen> createState() => _BlackBoxStartScreenState();
}

class _BlackBoxStartScreenState extends State<BlackBoxStartScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.blackBoxListScreen,
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
          title: 'Black Box',
          description: 'Analyze real world aviation \n scenarios',
          questions: 0,
          questionType: '',
          moduleType: 'Play more, earn more badges',
          iconWidget: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.Blackboxlogo),
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Black Box',
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
              child: GameDetailCardBlackBox(
                onStartGame: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BlackBoxLockScreen()),
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
