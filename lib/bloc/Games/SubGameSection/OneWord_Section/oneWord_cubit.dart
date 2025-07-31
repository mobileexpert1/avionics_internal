import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Quiz_Section/quiz_model.dart';

class OnewordCubit extends Cubit<OnewordState> {
  OnewordCubit()
      : super(OnewordState(games: [
    quizItem(title: 'Aircraft & Principles \nof Flight', isLocked: false),
    quizItem(title: 'Equipment & \nSystems', isLocked: false),
    quizItem(title: 'Airspace & \nProcedures', isLocked: false),
    quizItem(title: 'Meteorology & \nEnvironment', isLocked: false),
    quizItem(title: 'Regulations, Human Factors & Safety', isLocked: false),
    quizItem(title: 'Aviation Trivia & History', isLocked: false),
  ]));

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}
