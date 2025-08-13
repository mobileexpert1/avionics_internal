// import 'package:avionics_internal/bloc/Games/SubGameSection/Calculation_Section/calculation_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../Quiz_Section/quiz_model.dart';
//
// class CalculationCubit extends Cubit<CalculationState> {
//   CalculationCubit()
//       : super(CalculationState(games: [
//     quizItem(title: 'Take a measure', isLocked: false),
//     quizItem(title: 'Flight Math', isLocked: true),
//     quizItem(title: 'Green is new', isLocked: true),
//     quizItem(title: 'Exosphere', isLocked: true),
//   ]));
//
//   void unlockGame(int index) {
//     final updatedGames = List<quizItem>.from(state.games);
//     updatedGames[index] = updatedGames[index].copyWith(isLocked: false);
//     emit(state.copyWith(games: updatedGames));
//   }
// }
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

      final gameList = [
        quizItem(
          title: 'Take a Measure',
          isLocked: !(lockData.isEnableTakeMeasure ?? false),
        ),
        quizItem(
          title: 'Flight Math',
          isLocked: !(lockData.isEnableFlightMath ?? false),
        ),
        quizItem(
          title: 'Green is New Blue',
          isLocked: !(lockData.isEnableGreeNewBlue ?? false),
        ),
        quizItem(
          title: 'Mind the Separation',
          isLocked: !(lockData.isEnableMindSeparation ?? false),
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

