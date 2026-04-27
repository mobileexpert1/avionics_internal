import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/CalculationSection/CalculationLockScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

class CalculationDetailScreen extends StatefulWidget {
  final String gameId;

  const CalculationDetailScreen({super.key, required this.gameId});

  @override
  State<CalculationDetailScreen> createState() =>
      _CalculationDetailScreenState();
}

class _CalculationDetailScreenState extends State<CalculationDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.calculationsListScreen,
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
          title: 'Calculations',
          description: 'Complete the aviation sentence',
          questions: 10,
          questionType: 'aviation fill-in-the-blanks',
          moduleType: 'Topic wise modules',
          iconWidget: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.calculationDetail),
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Calculations',
          centerTitle: false,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CalculationLockScreen(),
                    ),
                  );
                  AnalyticsService.instance.buttonPressed(
                    FirebaseEvents.calculationsListButton,
                    FirebaseEvents.calculationsListScreen,
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
