import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Helpers/AppNavigator.dart';
import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';
import '../QuizSection/QuizQuestionScreen.dart';

class ImageBasedDetailScreen extends StatefulWidget {
  final String gameId;

  const ImageBasedDetailScreen({super.key, required this.gameId});

  @override
  State<ImageBasedDetailScreen> createState() => _ImageBasedDetailState();
}

class _ImageBasedDetailState extends State<ImageBasedDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.imageBasedDetailLockScreen,
    );
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
          title: 'PlaneSpotter',
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
          title: 'PlaneSpotter',
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
            constraints: BoxConstraints(
              maxWidth: isWeb ? 1500 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.all(isWeb ? screenWidth * 0.02 : 16),
              child: GameDetailCard(
                onStartGame: () {
                  AppNavigator.push(
                    context,
                    QuizQuestionScreen(
                      sectionId: 0,
                      sectionTitle: ConstantStrings.imageBasedTitle,
                      gameId: "imageBased",
                    ),
                    disableSwipeBack: true,
                  );
                  AnalyticsService.instance.buttonPressed(
                    FirebaseEvents.imageBasedDetailLockScreen,
                    FirebaseEvents.imageBasedLockScreen,
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
