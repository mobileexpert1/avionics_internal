import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_question_model.dart';

class QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool showAnswer;
  final int timer;
  final bool isTimerEnded;

  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedIndex,
    this.showAnswer = false,
    this.timer = 20,
    this.isTimerEnded = false,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];

  QuizState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedIndex,
    bool? showAnswer,
    int? timer,
    bool? isTimerEnded,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      showAnswer: showAnswer ?? this.showAnswer,
      timer: timer ?? this.timer,
      isTimerEnded: isTimerEnded ?? this.isTimerEnded,
    );
  }

  factory QuizState.initial() => const QuizState(questions: []);
}
