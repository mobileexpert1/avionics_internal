import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit()
      : super(QuizState(games: [
    quizItem(title: 'Stratosphere', isLocked: false),
    quizItem(title: 'Mesosphere', isLocked: true),
    quizItem(title: 'Thermosphere', isLocked: true),
    quizItem(title: 'Exosphere', isLocked: true),
    quizItem(title: 'Troposphere', isLocked: true),
  ]));

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}
