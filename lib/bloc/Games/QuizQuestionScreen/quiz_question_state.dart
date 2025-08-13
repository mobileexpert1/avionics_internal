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
  final int totalBonusPoints;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final List<QuestionResult> questionResults;
  final int pointsEarned;
  final int bonusPoints;
  final int timeTaken;

  final List<QuizQuestion> altitudeQuestions;
  final List<QuizQuestion> weightQuestions;
  final List<QuizQuestion> distanceQuestions;
  final List<QuizQuestion> fuelQuestions;
  final List<QuizQuestion> pressureQuestions;
  final List<QuizQuestion> speedQuestions;
  final List<QuizQuestion> temperatureQuestions;

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
    this.totalBonusPoints = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    required this.questionResults,
    this.pointsEarned = 0,
    this.bonusPoints = 0,
    this.timeTaken = 0,
    required this.altitudeQuestions,
    required this.weightQuestions,
    required this.distanceQuestions,
    required this.fuelQuestions,
    required this.pressureQuestions,
    required this.speedQuestions,
    required this.temperatureQuestions,
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
    int? totalBonusPoints,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    List<QuestionResult>? questionResults,
    int? pointsEarned,
    int? bonusPoints,
    int? timeTaken,
    List<QuizQuestion>? altitudeQuestions,
    List<QuizQuestion>? weightQuestions,
    List<QuizQuestion>? distanceQuestions,
    List<QuizQuestion>? fuelQuestions,
    List<QuizQuestion>? pressureQuestions,
    List<QuizQuestion>? speedQuestions,
    List<QuizQuestion>? temperatureQuestions,

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
      totalBonusPoints: totalBonusPoints ?? this.totalBonusPoints,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      questionResults: questionResults ?? this.questionResults,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      timeTaken: timeTaken ?? this.timeTaken,
      altitudeQuestions: altitudeQuestions ?? this.altitudeQuestions,
      weightQuestions: weightQuestions ?? this.weightQuestions,
      distanceQuestions: distanceQuestions ?? this.distanceQuestions,
      fuelQuestions: fuelQuestions ?? this.fuelQuestions,
      pressureQuestions: pressureQuestions ?? this.pressureQuestions,
      speedQuestions: speedQuestions ?? this.speedQuestions,
      temperatureQuestions: temperatureQuestions ?? this.temperatureQuestions,
    );
  }

  factory QuizQuestionState.initial() => const QuizQuestionState(
    questions: [],
    timePerQuestion: [],
    questionResults: [],
    pointsEarned: 0,
    bonusPoints: 0,
    timeTaken: 0,
    altitudeQuestions: [],
    weightQuestions: [],
    distanceQuestions: [],
    fuelQuestions: [],
    pressureQuestions: [],
    speedQuestions: [],
    temperatureQuestions: [],
  );
}
