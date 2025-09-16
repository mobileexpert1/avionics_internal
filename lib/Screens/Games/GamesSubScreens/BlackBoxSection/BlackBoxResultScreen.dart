import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';

class BlackBoxResultScreen extends StatelessWidget {
  const BlackBoxResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameResultCubit()
        ..setResult(
          title: "Game Completed!",
          score: 2,
          total: 4,
          totalPoints:4,
          correctPoints: 34,
          bonusPoints: [],
          badgeText: "",
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
                badgeText: null,
              );
            },
          ),
        ),
      ),
    );
  }
}
