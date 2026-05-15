import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/Games/GameResultCard.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_cubit.dart';
import '../../../../bloc/Games/SubGameSection/GameResult/result_state.dart';

class CalculationResultScreen extends StatefulWidget {
  const CalculationResultScreen({
    super.key,
    required this.totalQuestion,
    required this.correctedAnswer,
    required this.score,
    required this.isEarnedBadge,
    required this.badgeName,
    required this.bonusPoints,
  });

  final int totalQuestion;
  final int correctedAnswer;
  final int score;
  final bool isEarnedBadge;
  final String badgeName;
  final int bonusPoints;

  @override
  _CalculationResultScreenState createState() =>
      _CalculationResultScreenState();
}

class _CalculationResultScreenState extends State<CalculationResultScreen> {

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.calculationResultScreen,
    );
  }

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
              '+${widget.bonusPoints} point${widget.bonusPoints == 1 ? '' : 's'} for time bonus',
          ],
          badgeText: widget.isEarnedBadge
              ? '${widget.badgeName} badge earned'
              : null,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Result",
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
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
                    badgeText: state.badgeText,
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

