import 'package:avionics_internal/bloc/Games/SubGameSection/GameResult/result_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameResultCubit extends Cubit<GameResultState> {
  GameResultCubit() : super(GameResultState.initial());

  void setResult({
    required String title,
    required int score,
    required int total,
    required int totalPoints,
    required int correctPoints,
    required List<String> bonusPoints,
    String? badgeText,
  }) {
    emit(GameResultState(
      title: title,
      score: score,
      total: total,
      totalPoints: totalPoints,
      correctPoints: correctPoints,
      bonusPoints: bonusPoints,
      badgeText: badgeText,
    ));
  }
}
