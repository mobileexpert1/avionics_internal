import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Quiz_Section/quiz_model.dart';

class CalculationCubit extends Cubit<CalculationState> {
  CalculationCubit()
      : super(CalculationState(games: [
    quizItem(title: 'Take a measure', isLocked: false),
    quizItem(title: 'Flight Math', isLocked: true),
    quizItem(title: 'Green is new', isLocked: true),
    quizItem(title: 'Exosphere', isLocked: true),
  ]));

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}
