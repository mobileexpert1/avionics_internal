import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_repository.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';

class QuizQuestionCubit extends Cubit<QuizQuestionState> {
  Timer? _timer;
  final QuizQuestionRepository _repository;
  int maxQuestions = 20;

  bool isNoMoreQuestionArrived = false;
  final String gameId;
  int _totalDuration = 40;
  int _quizTypesId = 0;
  DateTime? _startTime;

  QuizQuestionCubit(
      int sectionId,
      BuildContext context, {
        required this.gameId,
        QuizQuestionRepository? repository,
      }) : _repository = repository ?? QuizQuestionRepository(),
        super(QuizQuestionState.initial()) {

    maxQuestions = gameId == "trivia" ? 5 : 20;

    const gameDurations = {"quiz": 180, "calculation": 40, "one_word": 40};
    _quizTypesId = sectionId;
    _totalDuration = gameDurations[gameId] ?? 40;
    loadQuestions(sectionId, context);
  }

  Future<void> loadQuestions(int sectionId, BuildContext context) async {
    try {
      emit(state.copyWith(isLoading: true));
      CalculationGameModel? gameData;

      if (gameId == "calculation") {
        gameData = await _repository.getCalculationData(sectionId, 3);
      } else if (gameId == "one_word") {
        gameData = await _repository.getOneWordData(sectionId, 3);
      } else if (gameId == "quiz") {
        gameData = await _repository.getQuizData(sectionId, 3);
      } else if (gameId == "trivia") {
        gameData = await _repository.getTriviaData(sectionId, 3);
      } else if (gameId == "imageBased") {
        gameData = await _repository.getImageBasedQuestionData(3);
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid gameId: $gameId',
          ),
        );
        return;
      }

      if (gameData == null || gameData.categoryTypes.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No questions available from API',
          ),
        );
        return;
      }


      // Map initial questions by category name
      final Map<String, List<QuizQuestion>> categorizedQuestions = {};
      for (var category in gameData.categoryTypes) {
        var questions = category.questions
            .map((q) => _mapQuestion(q, gameData!.setId, gameData.imageBasedId))
            .toList();
        categorizedQuestions[category.name] = questions;
      }

      // Initial questions capped at maxQuestions
      final allQuestions = gameData.categoryTypes
          .expand((category) => category.questions)
          .map((q) => _mapQuestion(q, gameData!.setId, gameData.imageBasedId))
          .take(maxQuestions)
          .toList();

      if (allQuestions.isEmpty) {
        print('No questions mapped from categories');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No questions could be mapped from API response',
          ),
        );
        return;
      }

      // Initialize results
      final initialResults = List<QuestionResult>.generate(
        maxQuestions,
            (index) => QuestionResult(
          userAnswerIndex: null,
          correctPoint: 0,
          bonusPoint: 0,
          timeTakenSeconds: 0,
        ),
      );

      // First emit (UI show)
      emit(
        state.copyWith(
          isLoading: false,
          questions: allQuestions,
          currentIndex: 0,
          selectedIndex: null,
          showAnswer: false,
          timer: _totalDuration,
          score: 0,
          correctAnswers: 0,
          wrongAnswers: 0,
          pointsEarned: 0,
          bonusPoints: 0,
          timeTaken: 0,
          questionResults: initialResults,
          timePerQuestion: List<int>.filled(maxQuestions, 0),
          categorizedQuestions: categorizedQuestions,
          game: gameData.game,
          level: gameData.level,
          difficulty: gameData.difficulty,
          categoryTypes: gameData.categoryTypes,
          setId: gameData.setId,
          imageBasedId: gameData.imageBasedId,
        ),
      );

      // Start timer
      startTimer(context);

      // Fetch silently in background if needed
      if (allQuestions.length < maxQuestions) {
        _fetchAndBufferBackgroundQuestions(sectionId, context);
      }
    } catch (e, stackTrace) {
      print('Error loading questions: $e, StackTrace: $stackTrace');
      if (e.toString().contains('Sorry no more')) {
        AppSnackBar.custom(
          context,
          message:
          'Please wait while more questions are loading. Try again later.',
          svgAsset: '',
        );

        Future.delayed(const Duration(seconds: 4), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      } else {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load questions: ${e.toString()}',
          ),
        );
      }
    }
  }

  QuizQuestion _mapQuestion(Question q, String setId, String imageBasedId) {
    final correctIndex = q.options.indexWhere((o) => o.label == q.answer);
    print(
      'Mapping question: ${q.question}, options: ${q.options.length}, answer: ${q.answer}, correctIndex: $correctIndex, questionId: ${q.questionId}',
    );
    if (correctIndex == -1) {
      // print(
      //   'Warning: No matching answer for question "${q.question}", answer: ${q.answer}',
      // );
    }
    return QuizQuestion(
      question: q.question,
      options: q.options.map((o) => o.value).toList(),
      correctIndex: correctIndex,
      hint: q.explanation,
      imgUrl: q.imgUrl,
      questionId: q.questionId,
      setId: setId,
      imageBasedId: imageBasedId,
    );
  }

  // Local buffer for silent background questions SD
  List<QuizQuestion> _bufferedQuestions = [];

  Future<void> _fetchAndBufferBackgroundQuestions(
      int sectionId,
      BuildContext context,
      ) async {
    for (int actionNumber = 1; actionNumber <= 2; actionNumber++) {
      if (state.questions.length + _bufferedQuestions.length >= maxQuestions) {
        break;
      }
      CalculationGameModel? additionalData;
      if (gameId == "calculation") {
        additionalData = await _repository.fetchAdditionalQuestions(
          sectionId,
          actionNumber,
        );
      } else if (gameId == "one_word") {
        additionalData = await _repository.fetchOneWordQuestions(
          sectionId,
          actionNumber,
        );
      } else if (gameId == "quiz") {
        additionalData = await _repository.fetchQuizQuestions(
          sectionId,
          actionNumber,
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid gameId for background fetch: $gameId',
          ),
        );
        return;
      }

      if (additionalData != null && additionalData.categoryTypes.isNotEmpty) {
        print(
          'Append Additional data for action $actionNumber: $additionalData',
        );
        await appendQuestionsSilently(additionalData, context);
      } else {
        print('No additional questions for action $actionNumber');
      }
    }

    if (state.questions.length + _bufferedQuestions.length == 0) {
      print('No questions after background fetch');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'No questions available after background fetch.',
        ),
      );
    }
  }

  Future<void> appendQuestionsSilently(
      CalculationGameModel additionalData,
      BuildContext context,
      ) async {
    if (state.questions.length + _bufferedQuestions.length >= maxQuestions) {
      return;
    }

    final newQuestions = additionalData.categoryTypes
        .expand((category) => category.questions)
        .map(
          (q) => _mapQuestion(
        q,
        additionalData.setId,
        additionalData.imageBasedId,
      ),
    )
        .take(
      maxQuestions - (state.questions.length + _bufferedQuestions.length),
    )
        .toList()
        .cast<QuizQuestion>();

    if (newQuestions.isNotEmpty) {
      _bufferedQuestions.addAll(newQuestions);
      print('All New Additional data for Append');
      if (isNoMoreQuestionArrived == true) {
        revealBufferedQuestions(context);
      }
    }
  }

  void revealBufferedQuestions(BuildContext context) {
    if (_bufferedQuestions.isEmpty) return;

    final updatedQuestions = [
      ...state.questions,
      ..._bufferedQuestions,
    ].take(maxQuestions).toList();

    _bufferedQuestions.clear();

    emit(state.copyWith(questions: updatedQuestions, isLoading: false));

    if (isNoMoreQuestionArrived == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All set! Taking you to the next question...'),
        ),
      );
      Future.delayed(const Duration(seconds: 4), () {
        isNoMoreQuestionArrived = false;
        nextQuestion(context);
      });
    }
  }

  void startTimer(BuildContext context) {
    print(
      "Current Quesiton correctIndex:- ${state.currentQuestion.correctIndex}",
    );

    _startTime = DateTime.now();
    emit(state.copyWith(timer: _totalDuration));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final remaining = _totalDuration - elapsed;

      if (remaining >= 0) {
        emit(
          state.copyWith(timer: remaining, selectedIndex: state.selectedIndex),
        );
        print("Pending time $remaining");
      } else {
        _timer?.cancel();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Times Up')));

        Future.delayed(const Duration(seconds: 2), () {
          emit(
            state.copyWith(
              showAnswer: true,
              isTimerEnded: true,
              timeTaken: 0,
              selectedIndex: state.currentQuestion.correctIndex,
            ),
          );
        });
      }
    });
  }

  Future<void> reportQuestionPostMethod(
      String reason,
      QuizQuestionCubit quizCubit,
      BuildContext context,
      String isForType,
      ) async {
    try {
      final currentQuestion = quizCubit.state.currentQuestion;

      // print(
      //   "imageBasedId:-${currentQuestion.imageBasedId}, "
      //   "setId:-${currentQuestion.setId}, "
      //   "questionId:-${currentQuestion.questionId}"
      //   "question:-${currentQuestion.question}, "
      //   "reason:-$reason",
      // );

      await _repository.reportQuestionPostMethod(
        setId: isForType == "imageBased"
            ? currentQuestion.imageBasedId
            : currentQuestion.setId,
        questionId: currentQuestion.questionId,
        reason: reason,
        isForType: isForType,
      );

      AppSnackBar.custom(
        context,
        message: "Question Report Successfully",
        svgAsset: "",
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);
      AppSnackBar.custom(context, message: e.toString(), svgAsset: "");
    }
  }

  void selectOption(int index) {
    emit(state.copyWith(selectedIndex: index, showAnswer: false));
  }

  Future<void> submitQuestion(BuildContext context) async {
    _timer?.cancel();

    final isCorrect = state.selectedIndex == state.currentQuestion.correctIndex;

    int timeBonus = isCorrect && state.timer >= _totalDuration / 2 ? 1 : 0;

    int pointsThisQuestion = isCorrect ? 2 : 0;
    int bonusPointsThisQuestion = timeBonus;

    final timeSpentThisQuestion = max(
      1,
      _totalDuration - state.timer,
    ); // Ensure minimum 1s
    final updatedResults = List<QuestionResult>.from(state.questionResults);
    final updatedTimePerQuestion = List<int>.from(state.timePerQuestion);

    updatedResults[state.currentIndex] = QuestionResult(
      userAnswerIndex: state.selectedIndex,
      correctPoint: pointsThisQuestion,
      bonusPoint: bonusPointsThisQuestion,
      timeTakenSeconds: timeSpentThisQuestion,
    );
    updatedTimePerQuestion[state.currentIndex] = timeSpentThisQuestion;

    final newPointsEarned = state.pointsEarned + pointsThisQuestion;
    final newBonusPoints = state.bonusPoints + bonusPointsThisQuestion;
    final newScore = state.score + pointsThisQuestion + bonusPointsThisQuestion;
    final newTimeTaken = state.timeTaken + timeSpentThisQuestion;

    emit(
      state.copyWith(
        questionResults: updatedResults,
        timePerQuestion: updatedTimePerQuestion,
        selectedIndex: state.selectedIndex,
        showAnswer: true,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
        score: newScore,
        pointsEarned: newPointsEarned,
        bonusPoints: newBonusPoints,
        timeTaken: newTimeTaken,
        isTimerEnded: true,
        totalBonusPoints: state.totalBonusPoints + timeBonus,
      ),
    );
  }

  Future<void> nextQuestion(BuildContext context) async {
    // If there are more questions → go to next
    if (state.currentIndex + 1 < state.questions.length) {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          selectedIndex: null,
          showAnswer: false,
          timer: _totalDuration,
          isTimerEnded: false,
        ),
      );

      startTimer(context);

      if (gameId == "quiz") {
        switch (state.currentIndex) {
          case 10:
            _totalDuration = 150;
            break;
          case 14:
            _totalDuration = 90;
            break;
        }
        _timer?.cancel();
        startTimer(context);
      }
      if (state.currentIndex == 9 || state.currentIndex == 13) {
        revealBufferedQuestions(context);
      }
    }
    // Last question → submit + navigate
    else if (state.currentIndex == maxQuestions - 1) {
      _timer?.cancel();

      String formatTime(int seconds) => "${seconds}s";
      String indexToLetter(int? index) {
        if (index == null) return "";
        return String.fromCharCode(65 + index);
      }

      // Map category names to numeric type IDs if not provided
      final categoryTypeMap = <String, String>{};
      state.categoryTypes.asMap().forEach((index, category) {
        categoryTypeMap[category.name] = category.type.isNotEmpty
            ? category.type
            : "${index + 1}";
      });

      final categories = state.categorizedQuestions.entries.map((entry) {
        final categoryName = entry.key;
        final questions = entry.value;
        final categoryType = categoryTypeMap[categoryName] ?? categoryName;
        return {
          "category_type": categoryType,
          "category_name": formatCategoryName(categoryName),
          // Format for display
          "questions": questions.map((q) {
            final resultIndex = state.questions.indexOf(q);
            final result = resultIndex != -1
                ? state.questionResults[resultIndex]
                : QuestionResult(
              userAnswerIndex: null,
              correctPoint: 0,
              bonusPoint: 0,
              timeTakenSeconds: 0,
            );
            return {
              "question": q.question,
              "options": List.generate(
                q.options.length,
                    (optIndex) => {
                  "label": String.fromCharCode(65 + optIndex),
                  "value": q.options[optIndex],
                },
              ),
              "answer": indexToLetter(q.correctIndex),
              "explanation": q.hint,
              "img_url": q.imgUrl,
              "user_answered": indexToLetter(result.userAnswerIndex),
              "correct_point": result.correctPoint,
              "bonus_point": result.bonusPoint,
              "time_taken": formatTime(result.timeTakenSeconds),
            };
          }).toList(),
        };
      }).toList();

      // Final totals
      final allCorrectBonus = (state.correctAnswers == maxQuestions) ? 3 : 0;
      final finalScore = state.score + allCorrectBonus;

      final payload = {
        "total_questions": maxQuestions,
        "correct_answers": state.correctAnswers,
        "correct_points": state.pointsEarned,
        "earned_points": finalScore,
        "additional_points": state.bonusPoints,
        "total_time": formatTime(state.timeTaken),
        "game": state.game,
        "level": state.level,
        "difficulty": state.difficulty,
        "categories": categories,
        "game_number": _quizTypesId,
        "set_id": gameId == "imageBased" ? state.imageBasedId : state.setId,
        "img_id": state.imageBasedId,
      };

      debugPrint("🚀 QUIZ SUBMIT PAYLOAD:");
      debugPrint(JsonEncoder.withIndent('  ').convert(payload));

      try {
        final response = await QuizQuestionRepository().submitResult(
          payload,
          gameId,
        );

        if (response.detail.toLowerCase() ==
            "quiz answer submitted successfully".toLowerCase()) {
          final data = response.data;
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CalculationResultScreen(
                  correctedAnswer: data.correctAnswers,
                  totalQuestion: data.totalQuestions,
                  score: data.earnedPoints,
                  bonusPoints: data.additionalPoints,
                  isEarnedBadge: data.isEarnedBadge,
                  badgeName: data.badgeName,
                ),
              ),
            );

            AnalyticsService.instance.buttonPressed(
              FirebaseEvents.calculationsListButton,
              FirebaseEvents.calculationResultScreen,
            );
          });
        } else {
          SessionCommonTokenError.handleUnauthorizedError(context, e);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Result submit failed. Try again.")),
          );
          emit(
            state.copyWith(errorMessage: "Result submit failed. Try again."),
          );
        }
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit results: $e')));
        emit(state.copyWith(errorMessage: 'Failed to submit results: $e'));
      }
    }
    // If loading more
    else if (state.isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait, more questions are loading...'),
        ),
      );
    } else {
      isNoMoreQuestionArrived = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please hold on while we load the next set of questions…',
          ),
        ),
      );
    }
  }

  String formatCategoryName(String name) {
    return name
        .split('_')
        .map((word) => word[0].toLowerCase() + word.substring(1))
        .join(' ');
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

