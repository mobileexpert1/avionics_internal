import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_result_model.dart';

class QuizQuestionState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final bool showAnswer;
  final int timer;
  final bool isTimerEnded;
  final int correctAnswers;
  final int wrongAnswers;
  final int score;
  final List<int> timePerQuestion;
  final bool winAchieved;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<QuestionResult> questionResults;
  final int pointsEarned;
  final int bonusPoints;
  final int timeTaken;
  final int totalBonusPoints;

  const QuizQuestionState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedIndex,
    this.showAnswer = false,
    this.timer = 40, // ⏱ Default timer is 40 seconds
    this.isTimerEnded = false,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.score = 0,
    required this.timePerQuestion,
    this.winAchieved = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    required this.questionResults,
    this.pointsEarned = 0,
    this.bonusPoints = 0,
    this.timeTaken = 0,
    this.totalBonusPoints = 0,
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
    int? score,
    List<int>? timePerQuestion,
    bool? winAchieved,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<QuestionResult>? questionResults,
    int? pointsEarned,
    int? bonusPoints,
    int? timeTaken,
    int? totalBonusPoints,

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
      score: score ?? this.score,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      winAchieved: winAchieved ?? this.winAchieved,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      questionResults: questionResults ?? this.questionResults,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      timeTaken: timeTaken ?? this.timeTaken,
      totalBonusPoints: totalBonusPoints ?? this.totalBonusPoints,
    );
  }

  factory QuizQuestionState.initial() => const QuizQuestionState(
    questions: [],
    timePerQuestion: [],
    questionResults: [],
    pointsEarned: 0,
    bonusPoints: 0,
    timeTaken: 0,
  );
}
