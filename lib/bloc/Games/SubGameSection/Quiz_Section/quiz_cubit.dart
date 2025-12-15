import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../OneWord_Section/oneWord_repository.dart';
import '../OneWord_Section/oneWord_state.dart';

class QuizCubit extends Cubit<OneWordTopicState> {
  QuizCubit() : super(OneWordTopicState());

  Future<void> loadQuizTopics(BuildContext context) async {
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
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}