import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../Quiz_Section/quiz_model.dart';
import 'blackBox_repository.dart';
import 'blackBox_state.dart';

class BlackboxCubit extends Cubit<BlackBoxState> {
  BlackboxCubit() : super(const BlackBoxState());

  Future<void> loadBlackboxSummary({required BuildContext context}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        status: CommonApiStatus.submitting,
        errorMessage: null,
        apiError: null,
        blackboxModels: null,
      ),
    );

    try {
      final blackboxModels = await BlackboxRepository().getBlackboxSummary();
      if (blackboxModels != null) {
        emit(
          state.copyWith(
            blackboxModels: blackboxModels,
            isLoading: false,
            isSuccess: true,
            status: CommonApiStatus.success,
            errorMessage: null,
            apiError: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            status: CommonApiStatus.failure,
            errorMessage: 'No data received from the server',
            apiError: 'No data available',
          ),
        );
      }
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
          apiError: 'Failed to fetch data',
        ),
      );
    }
  }

  Future<void> loadBlackBoxTopics(BuildContext context) async {
    try {
      emit(state.copyWith(isLoading: true));

      final response = await BlackboxRepository().getBlackBoxTopic();

      if (response == null || response.data.isEmpty) {
        emit(state.copyWith(isLoading: false, games: []));
        return;
      }
      final List<quizItem> gameList = response.data.map((game) {
        return quizItem(
          title: game.name,
          gameNumber: game.gameNumber,
          isLocked: !game.isEnable,
          info: game.info,
        );
      }).toList();

      emit(state.copyWith(games: gameList, isLoading: false));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
