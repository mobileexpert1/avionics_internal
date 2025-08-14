import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Quiz_Section/quiz_model.dart';

class OnewordCubit extends Cubit<OnewordState> {
  OnewordCubit()
      : super(OnewordState(games: [
    quizItem(title: 'Aircraft & Principles \nof Flight', isLocked: false, gameNumber: 1),
    quizItem(title: 'Equipment & \nSystems', isLocked: false, gameNumber: 2),
    quizItem(title: 'Airspace & \nProcedures', isLocked: false, gameNumber: 3),
    quizItem(title: 'Meteorology & \nEnvironment', isLocked: false, gameNumber: 4),
    quizItem(title: 'Regulations, Human Factors & Safety', isLocked: false, gameNumber: 5),
    quizItem(title: 'Aviation Trivia & History', isLocked: false, gameNumber: 6),
  ]));

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}
