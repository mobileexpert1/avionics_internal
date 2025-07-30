import 'package:equatable/equatable.dart';
import '../Quiz_Section/quiz_model.dart';

class OnewordState extends Equatable {
  final List<quizItem> games;

  const OnewordState({required this.games});

  OnewordState copyWith({List<quizItem>? games}) {
    return OnewordState(games: games ?? this.games);
  }

  @override
  List<Object?> get props => [games];
}
