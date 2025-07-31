import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';

class QuizQuestionState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool showAnswer;
  final int timer;
  final bool isTimerEnded;
  final int correctAnswers;
  final int wrongAnswers;

  const QuizQuestionState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedIndex,
    this.showAnswer = false,
    this.timer = 20,
    this.isTimerEnded = false,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
  });

  QuizQuestion get currentQuestion => questions[currentIndex];

  QuizQuestionState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedIndex,
    bool? showAnswer,
    int? timer,
    bool? isTimerEnded,
    int? correctAnswers,
    int? wrongAnswers,
  }) {
    return QuizQuestionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      showAnswer: showAnswer ?? this.showAnswer,
      timer: timer ?? this.timer,
      isTimerEnded: isTimerEnded ?? this.isTimerEnded,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
    );
  }

  factory QuizQuestionState.initial() => const QuizQuestionState(questions: []);
}
