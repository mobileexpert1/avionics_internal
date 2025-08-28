import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_repository.dart';
import '../Quiz_Section/quiz_model.dart';

class QuizCubit extends Cubit<OneWordTopicState> {
  QuizCubit() : super(OneWordTopicState());

  Future<void> loadQuizTopics() async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await OneWordTopicRepository().getQuizTopic();

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
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
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