import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'calculation_lock_model.dart';
import '../Quiz_Section/quiz_model.dart';

class CalculationState {
  final CalculationLock? calculationLock;
  final List<quizItem> games;
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
    List<quizItem>? games,
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
