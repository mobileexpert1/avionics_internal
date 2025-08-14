import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit()
      : super(QuizState(games: [
    quizItem(title: 'Stratosphere', isLocked: false, gameNumber: 1),
    quizItem(title: 'Mesosphere', isLocked: true, gameNumber: 2),
    quizItem(title: 'Thermosphere', isLocked: true, gameNumber: 3),
    quizItem(title: 'Exosphere', isLocked: true, gameNumber: 4),
    quizItem(title: 'Troposphere', isLocked: true, gameNumber: 5),
  ]));

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}
