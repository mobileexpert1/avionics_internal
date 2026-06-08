import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_repository.dart';
import 'package:avionics_internal/bloc/Games/SubGameSection/OneWord_Section/oneWord_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../../Helpers/NoInternetDialog.dart';
import '../Quiz_Section/quiz_model.dart';

class OneWordCubit extends Cubit<OneWordTopicState> {
  OneWordCubit() : super(OneWordTopicState());

  Future<void> loadOneWordTopics(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true));
        final response = await OneWordTopicRepository().getOneWordTopic();
        if (response != null) {
          final List<QuizPerItem> gameList = response.data.map((oneWord) {
            return QuizPerItem(
              title: oneWord.name,
              isLocked: !(oneWord.isEnable),
              gameNumber: oneWord.gameNumber,
              info: oneWord.info,
            );
          }).toList();

          emit(state.copyWith(games: gameList, isLoading: false));
        } else {
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    }else{
      NoInternetDialog.show(
        context,
        onRetry: () => loadOneWordTopics(context),
      );
    }
  }
}
