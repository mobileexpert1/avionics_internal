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

      // 🔹 Static BlackBox game topics
      final List<quizItem> gameList = [
        quizItem(
          title: 'Black Box Basics',
          isLocked: false,
          gameNumber: 1,
          info: [
            'Introduction to aircraft black box and its purpose',
          ],
        ),
        quizItem(
          title: 'Cockpit Voice Recorder (CVR)',
          isLocked: false,
          gameNumber: 2,
          info: [
            'Understand how CVR records cockpit communications',
          ],
        ),
        quizItem(
          title: 'Flight Data Recorder (FDR)',
          isLocked: true,
          gameNumber: 3,
          info: [
            'Learn how flight parameters are stored in FDR',
          ],
        ),
        quizItem(
          title: 'Accident Investigation',
          isLocked: true,
          gameNumber: 4,
          info: [
            'Role of black box in aircraft accident investigation',
          ],
        ),
        quizItem(
          title: 'Survivability & Recovery',
          isLocked: true,
          gameNumber: 5,
          info: [
            'How black boxes survive crashes and are recovered',
          ],
        ),
      ];


      emit(
        state.copyWith(
          games: gameList,
          isLoading: false,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
