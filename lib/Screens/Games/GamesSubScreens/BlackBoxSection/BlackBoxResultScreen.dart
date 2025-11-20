import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';

class BlackBoxResultScreen extends StatefulWidget {
  const BlackBoxResultScreen({
    super.key,
    required this.totalQuestion,
    required this.correctedAnswer,
    required this.score,
    required this.winAchieved,
    required this.bonusPoints,
    required this.correctPoints,
  });

  final int totalQuestion;
  final int correctedAnswer;
  final int score;
  final bool winAchieved;
  final int bonusPoints;
  final int correctPoints;

  @override
  State<BlackBoxResultScreen> createState() => _BlackBoxResultScreenState();
}

class _BlackBoxResultScreenState extends State<BlackBoxResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameResultCubit()
        ..setResult(
          title: "Game Completed!",
          score: widget.correctedAnswer,
          total: widget.totalQuestion,
          totalPoints: widget.score,
          correctPoints: widget.correctPoints,
          bonusPoints: [
            if (widget.bonusPoints > 0)
              '+${widget.bonusPoints} point${widget.bonusPoints == 1 ? '' : 's'} for time bonus',
          ],
          badgeText: widget.winAchieved ? "Winner!" : "",
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
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
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
        ),
      ),
    );
  }
}
