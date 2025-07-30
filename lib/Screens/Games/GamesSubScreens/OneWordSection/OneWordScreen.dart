import 'package:avionics_internal/Constants/constantImages.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/Screens/Games/GamesSubScreens/OneWordSection/OneWordTopicScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Helpers/Games/GameInfoCard.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_cubit.dart';
import '../../../../bloc/Games/MainGameSection/GameDetail/gameInfo_model.dart';


class OneWordDetailScreen extends StatelessWidget {
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
          iconWidget: Container(
            width: 100.0,
            height: 100.0,
            decoration: const BoxDecoration(
              color: Color(0xFF1E80F2),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                CommonUi.setSvgImage(AssetsPath.oneWord),
                fit: BoxFit.cover,
              ),
            ),
          ),
          isTopicWise: true,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'One word game',
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GameDetailCard(
            onStartGame: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OneWordTopicScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
