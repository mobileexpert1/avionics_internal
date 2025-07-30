import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';

class QuizQuestionState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool showAnswer;
  final int timer;
  final bool isTimerEnded;

  const QuizQuestionState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedIndex,
    this.showAnswer = false,
    this.timer = 20,
    this.isTimerEnded = false,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];

  QuizQuestionState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedIndex,
    bool? showAnswer,
    int? timer,
    bool? isTimerEnded,
  }) {
    return QuizQuestionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      showAnswer: showAnswer ?? this.showAnswer,
      timer: timer ?? this.timer,
      isTimerEnded: isTimerEnded ?? this.isTimerEnded,
    );
  }

  factory QuizQuestionState.initial() => const QuizQuestionState(questions: []);
}
