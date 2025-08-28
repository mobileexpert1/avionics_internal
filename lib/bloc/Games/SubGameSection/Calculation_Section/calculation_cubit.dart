import 'package:flutter_bloc/flutter_bloc.dart';
import '../OneWord_Section/oneWord_repository.dart';
import 'calculation_state.dart';
import '../Quiz_Section/quiz_model.dart';

class CalculationCubit extends Cubit<CalculationState> {
  CalculationCubit() : super(const CalculationState());

  Future<void> loadCalculationLocks() async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await OneWordTopicRepository().getCalculationTopic();

      if (response != null) {
        final List<quizItem> gameList = response.data.map((oneWord) {
          return quizItem(
            title: oneWord.name,
            isLocked: !(oneWord.isEnable),
            gameNumber: oneWord.gameNumber,
            info: oneWord.info,
          );
        }).toList();

        emit(state.copyWith(
          games: gameList,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load calculation games.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while loading games. Please try again later.',
      ));
    }
  }

  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    if (index >= 0 && index < updatedGames.length) {
      updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
      emit(state.copyWith(games: updatedGames));
    }
  }
}