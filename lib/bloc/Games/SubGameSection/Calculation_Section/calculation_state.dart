import 'package:equatable/equatable.dart';
import '../Quiz_Section/quiz_model.dart';

class CalculationState extends Equatable {
  final List<quizItem> games;

  const CalculationState({required this.games});

  CalculationState copyWith({List<quizItem>? games}) {
    return CalculationState(games: games ?? this.games);
  }

  @override
  List<Object?> get props => [games];
}
