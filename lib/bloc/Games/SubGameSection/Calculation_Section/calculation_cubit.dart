import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculation_repository.dart';
import 'calculation_state.dart';
import '../Quiz_Section/quiz_model.dart';

class CalculationCubit extends Cubit<CalculationState> {
  CalculationCubit() : super(const CalculationState());

  Future<void> loadCalculationLocks() async {
    emit(state.copyWith(isLoading: true));

    try {
      final lockData = await CalculationLockRepository().getCalculationLock();

      if (lockData == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "No internet or failed to fetch data",
        ));
        return;
      }

      // Create gameList with indices aligned to game_no_assign (1-based indexing)
      final gameList = [
        quizItem(
          title: 'Take a Measure',
          isLocked: !(lockData.isEnableTakeMeasure ?? false),
          gameNumber: 1, // Maps to take_measure
        ),
        quizItem(
          title: 'Flight Math',
          isLocked: !(lockData.isEnableFlightMath ?? false),
          gameNumber: 2, // Maps to flight_math
        ),
        quizItem(
          title: 'Green is New Blue',
          isLocked: !(lockData.isEnableGreeNewBlue ?? false),
          gameNumber: 3, // Maps to gree_new_blue
        ),
        quizItem(
          title: 'Mind the Separation',
          isLocked: !(lockData.isEnableMindSeparation ?? false),
          gameNumber: 4, // Maps to mind_separation
        ),
      ];

      emit(state.copyWith(
        games: gameList,
        calculationLock: lockData,
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }


  void unlockGame(int index) {
    final updatedGames = List<quizItem>.from(state.games);
    updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
    emit(state.copyWith(games: updatedGames));
  }
}

