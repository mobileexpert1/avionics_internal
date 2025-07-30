import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';

class OneWordResultScreen extends StatelessWidget {
  const OneWordResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameResultCubit()
        ..setResult(
          title: "Game Complete!",
          score: 7,
          total: 10,
          totalPoints: 16,
          correctPoints: 14,
          bonusPoints: ["+2 points for time bonus"],
          badgeText: "Weather Navigator Badge Earned Master Badge",
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Result",
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GameResultCubit, GameResultState>(
            builder: (context, state) {
              return GameResultCard(
                title: state.title,
                score: state.score,
                total: state.total,
                totalPoints: state.totalPoints,
                correctPoints: state.correctPoints,
                bonusPoints: state.bonusPoints,
                badgeText: state.badgeText,
                onBackTap: () => Navigator.pop(context),
              );
            },
          ),
        ),
      ),
    );
  }
}
