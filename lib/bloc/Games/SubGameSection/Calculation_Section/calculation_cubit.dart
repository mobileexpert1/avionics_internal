import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Helpers/NoInternetDialog.dart';
import '../OneWord_Section/oneWord_repository.dart';
import '../Quiz_Section/quiz_model.dart';
import 'calculation_state.dart';

class CalculationCubit extends Cubit<CalculationState> {
  CalculationCubit() : super(const CalculationState());

  Future<void> loadCalculationLocks(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true));
        final response = await OneWordTopicRepository().getCalculationTopic();
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
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'Failed to load calculation games.',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'An error occurred while loading games. Please try again later.',
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadCalculationLocks(context),
      );
    }
  }
}
