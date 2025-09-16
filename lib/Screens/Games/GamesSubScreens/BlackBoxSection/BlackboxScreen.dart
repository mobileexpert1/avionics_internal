import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/QuizSection/QuizLockScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';

class BlackBoxStartScreen extends StatelessWidget {
  final String gameId;

  const BlackBoxStartScreen({super.key, required this.gameId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameDetailCubit(
        GameInfo(
          title: 'Black Box',
          description: 'Analyze real world aviation \n scenarios',
          questions: 0,
          questionType: 'Solve aviation problems',
          moduleType: 'Play more, earn more badges',
          iconWidget: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.blackBox),
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Black Box',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GameDetailCardBlackBox(
            onStartGame: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizLockScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
