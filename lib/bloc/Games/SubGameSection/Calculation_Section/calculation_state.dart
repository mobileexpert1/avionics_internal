import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/constantImages.dart';
import '../Quiz_Section/quiz_model.dart';
import 'calculation_lock_model.dart';

class CalculationState {
  final CalculationLock? calculationLock;
  final List<QuizPerItem> games;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const CalculationState({
    this.calculationLock,
    this.games = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  CalculationState copyWith({
    CalculationLock? calculationLock,
    List<QuizPerItem>? games,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return CalculationState(
      calculationLock: calculationLock ?? this.calculationLock,
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}

List<String> returnCalculationImages(String calculationName) {
  if (calculationName.contains("measure")) {
    return [AssetsPath.takeMeasureUnSelected, AssetsPath.takeMeasureSelected];
  } else if (calculationName.contains("Flight")) {
    return [AssetsPath.flightMathUnSelected, AssetsPath.flightMathSelected];
  } else if (calculationName.contains("Green")) {
    return [AssetsPath.greenBlueUnSelected, AssetsPath.greenBlueSelected];
  } else if (calculationName.contains("Separation")) {
    return [
      AssetsPath.mindSeparationUnSelected,
      AssetsPath.mindSeparationSelected,
    ];
  }
  return [];
}

String returnCalculationDescription(String calculationName) {
  if (calculationName.contains("measure")) {
    return "Distance, speed, time and conversion tools.";
  } else if (calculationName.contains("Flight")) {
    return "Perform aviation math's with ease.";
  } else if (calculationName.contains("Green")) {
    return "Find the shortest route every time.";
  } else if (calculationName.contains("Separation")) {
    return "Search minimum and maximum values.";
  }
  return "";
}
