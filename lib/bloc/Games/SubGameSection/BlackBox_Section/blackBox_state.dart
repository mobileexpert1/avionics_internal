import 'package:avionics_internal/bloc/Games/SubGameSection/Quiz_Section/quiz_model.dart';
import 'package:equatable/equatable.dart';
import 'blackBox_model.dart';
import 'blackBox_question_model.dart';

enum CommonApiStatus { initial, submitting, success, failure }

class BlackBoxState extends Equatable {
  final String? questionSetId;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;
  final List<BlackBoxSummaryModel>? blackboxModels;
  final List<BlackBoxQuestion> questions;
  final int currentIndex;
  final int? selectedIndex;
  final String? selectedAnswer; // For fill_in_the_blank
  final bool showAnswer;
  final int timer;
  final bool isTimerEnded;
  final int correctAnswers;
  final int wrongAnswers;
  final int score;
  final List<int> timePerQuestion;
  final bool winAchieved;
  final int totalBonusPoints;
  final List<BlackBoxQuestionResult> questionResults;
  final int pointsEarned;
  final int bonusPoints;
  final int timeTaken;
  final Map<String, List<BlackBoxQuestion>> categorizedQuestions;
  final String game;
  final String level;
  final String difficulty;
  final List<CategoryTypes> categoryTypes;
  final List<int>? selectedSequence;
  final List<String>? selectedSequenceItems;
  final List<int>? selectedIndices;
  final List<quizItem> games;

  const BlackBoxState({
    this.questionSetId,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.blackboxModels,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedIndex,
    this.selectedAnswer,
    this.showAnswer = false,
    this.timer = 40,
    this.isTimerEnded = false,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.score = 0,
    this.timePerQuestion = const [],
    this.winAchieved = false,
    this.totalBonusPoints = 0,
    this.questionResults = const [],
    this.pointsEarned = 0,
    this.bonusPoints = 0,
    this.timeTaken = 0,
    this.categorizedQuestions = const {},
    this.game = '',
    this.level = '',
    this.difficulty = '',
    this.categoryTypes = const [],
    this.selectedSequence,
    this.selectedSequenceItems,
    this.selectedIndices = const [],
    this.games = const [],
  });

  BlackBoxState copyWith({
    String? questionSetId,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
    List<BlackBoxSummaryModel>? blackboxModels,
    List<BlackBoxQuestion>? questions,
    int? currentIndex,
    int? selectedIndex,
    String? selectedAnswer,
    bool? showAnswer,
    int? timer,
    bool? isTimerEnded,
    int? correctAnswers,
    int? wrongAnswers,
    int? score,
    List<int>? timePerQuestion,
    bool? winAchieved,
    int? totalBonusPoints,
    List<BlackBoxQuestionResult>? questionResults,
    int? pointsEarned,
    int? bonusPoints,
    int? timeTaken,
    Map<String, List<BlackBoxQuestion>>? categorizedQuestions,
    String? game,
    String? level,
    String? difficulty,
    List<CategoryTypes>? categoryTypes,
    List<int>? selectedSequence,
    List<String>? selectedSequenceItems,
    List<int>? selectedIndices,
    List<quizItem>? games,
  }) {
    return BlackBoxState(
      questionSetId: questionSetId ?? this.questionSetId,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
      blackboxModels: blackboxModels ?? this.blackboxModels,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      showAnswer: showAnswer ?? this.showAnswer,
      timer: timer ?? this.timer,
      isTimerEnded: isTimerEnded ?? this.isTimerEnded,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      score: score ?? this.score,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      winAchieved: winAchieved ?? this.winAchieved,
      totalBonusPoints: totalBonusPoints ?? this.totalBonusPoints,
      questionResults: questionResults ?? this.questionResults,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      timeTaken: timeTaken ?? this.timeTaken,
      categorizedQuestions: categorizedQuestions ?? this.categorizedQuestions,
      game: game ?? this.game,
      level: level ?? this.level,
      difficulty: difficulty ?? this.difficulty,
      categoryTypes: categoryTypes ?? this.categoryTypes,
      selectedSequence: selectedSequence ?? this.selectedSequence,
      selectedSequenceItems:
      selectedSequenceItems ?? this.selectedSequenceItems,
      selectedIndices: selectedIndices ?? this.selectedIndices,
      games: games ?? this.games,
    );
  }

  BlackBoxQuestion get currentQuestion => questions.isNotEmpty
      ? questions[currentIndex]
      : BlackBoxQuestion(
    question: '',
    options: [],
    correctIndex: -1,
    hint: '',
    type: '',
    title: 'Question',
    name: '',
  );

  @override
  List<Object?> get props => [
    questionSetId,
    isLoading,
    isSuccess,
    errorMessage,
    apiError,
    status,
    blackboxModels,
    questions,
    currentIndex,
    selectedIndex,
    selectedAnswer,
    showAnswer,
    timer,
    isTimerEnded,
    correctAnswers,
    wrongAnswers,
    score,
    timePerQuestion,
    winAchieved,
    totalBonusPoints,
    questionResults,
    pointsEarned,
    bonusPoints,
    timeTaken,
    categorizedQuestions,
    questionSetId,
    game,
    level,
    difficulty,
    categoryTypes,
    selectedSequence,
    selectedSequenceItems,
    selectedIndices,
    games,
  ];
}

// ------------------ BlackBoxQuestion Model ------------------

class BlackBoxQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String hint;
  final String type;
  final List<int>? correctSequence;
  final List<String>? sequenceItems;
  final String? correctAnswer;
  final String? title;
  final String? name;
  final List<int>? correctOptionList;
  final String? questionId; // Added question_id field
  final String? explanation; // optional explanation from API

  BlackBoxQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.hint,
    required this.type,
    this.correctSequence,
    this.sequenceItems,
    this.correctAnswer,
    this.title,
    this.name,
    this.correctOptionList,
    this.questionId,
    this.explanation,
  });

  /// Optional: Helper factory for parsing from JSON
  factory BlackBoxQuestion.fromJson(Map<String, dynamic> json) {
    return BlackBoxQuestion(
      question: json['question'] ?? '',
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e['value'] as String)
          .toList() ??
          [],
      correctIndex: json['answer'] != null
          ? _computeCorrectIndex(json['answer'], json['options'])
          : -1,
      hint: json['explanation'] ?? '',
      type: json['type'] ?? '',
      title: json['title'],
      questionId: json['question_id'],
    );
  }

  static int _computeCorrectIndex(String answer, List<dynamic>? options) {
    if (options == null || options.isEmpty) return -1;
    for (int i = 0; i < options.length; i++) {
      if (options[i]['label'] == answer || options[i]['value'] == answer) {
        return i;
      }
    }
    return -1;
  }
}

// ------------------ BlackBoxQuestionResult Model ------------------

class BlackBoxQuestionResult {
  final int? userAnswerIndex;
  final List<int>? userSequence;
  final String? userAnswer;
  final int correctPoint;
  final int bonusPoint;
  final int timeTakenSeconds;
  final List<int>? selectedIndices;

  BlackBoxQuestionResult({
    this.userAnswerIndex,
    this.userSequence,
    this.userAnswer,
    required this.correctPoint,
    required this.bonusPoint,
    required this.timeTakenSeconds,
    required this.selectedIndices,
  });
}
