import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';
import '../../MainGameScreen/GameScreen.dart';

class CalculationResultScreen extends StatefulWidget {
  const CalculationResultScreen({
    super.key,
    required this.totalQuestion,
    required this.correctedAnswer,
    required this.score,
    required this.winAchieved,
    required this.bonusPoints,
  });

  final int totalQuestion;
  final int correctedAnswer;
  final int score;
  final bool winAchieved;
  final int bonusPoints;

  @override
  _CalculationResultScreenState createState() => _CalculationResultScreenState();
}

class _CalculationResultScreenState extends State<CalculationResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameResultCubit()
        ..setResult(
          title: "Game Complete!",
          score: widget.correctedAnswer,
          total: widget.totalQuestion,
          totalPoints: widget.score,
          correctPoints: widget.correctedAnswer * 2,
          bonusPoints: [
            if (widget.bonusPoints > 0)
              '+${widget.bonusPoints} point${widget.bonusPoints == 1 ? '' : 's'} for speed bonus',
            (widget.winAchieved == false
                ? ''
                : '+3 points for perfectly correct \nanswers'),
          ],
          badgeText: widget.winAchieved ? 'Aviation Master Badge Earned' : null,
        ),

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Result",
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
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
                // onBackTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => const GamesScreen()),
                // ),
              );
            },
          ),
        ),
      ),
    );
  }
}