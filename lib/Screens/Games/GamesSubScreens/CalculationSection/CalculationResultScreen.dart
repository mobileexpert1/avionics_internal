import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';

class CalculationResultScreen extends StatefulWidget {
  const CalculationResultScreen({
    super.key,
    required this.totalQuestion,
    required this.correctedAnswer,
  });

  final int totalQuestion;
  final int correctedAnswer;

  @override
  _CalculationResultScreenState createState() =>
      _CalculationResultScreenState();
}

class _CalculationResultScreenState extends State<CalculationResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameResultCubit()
        ..setResult(
          title: "Game Completed!",
          score: 20,
          total: widget.totalQuestion,
          totalPoints: 53,
          correctPoints: widget.correctedAnswer,
          bonusPoints: [
            "+10 points for speed bonus",
            "+3 points for perfectly correct answers",
          ],
          badgeText: "Conversion Cadet Badge Earned",
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Result",
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
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
                onBackTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              );
            },
          ),
        ),
      ),
    );
  }
}
