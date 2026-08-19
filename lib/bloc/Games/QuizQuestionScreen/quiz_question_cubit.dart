import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_repository.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../CustomFiles/Custom_SnackBar.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/NoInternetDialog.dart';
import '../../../Screens/Games/GamesSubScreens/JettingAroundTheWorld/AviationChroniclePopup.dart';
import '../../../Screens/Games/GamesSubScreens/JettingAroundTheWorld/JettingAroundResultPopup.dart';
import '../../../Screens/Games/GamesSubScreens/JettingAroundTheWorld/JettingAroundTheWorldScreen.dart';
import '../../../Screens/Games/GamesSubScreens/ResultScreen/MainResultScreen.dart';
import '../../../Screens/Games/MainGameScreen/BaseScreenForAllLevelDescriptions.dart';
import '../../../Screens/Profile/ProfileMenuScreen/7_AirplaneSection/AirplanePartsScreen.dart';
import '../../../Screens/Profile/ProfileMenuScreen/7_AirplaneSection/PartUnlockScreen.dart';
import '../../../Screens/Profile/ProfileMenuScreen/7_AirplaneSection/PlaneSpotterResultDialog.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';
import '../SubGameSection/JettingAroundTheWorld/jettingTheWorld_cubit.dart';

class QuizQuestionCubit extends Cubit<QuizQuestionState> {
  Timer? _timer;
  final QuizQuestionRepository _repository;
  int maxQuestions = 20;

  bool isNoMoreQuestionArrived = false;
  final String gameId;
  int _totalDuration = 40;
  int _quizTypesId = 0;
  DateTime? _startTime;
  final List<QuizQuestion> _bufferedQuestions = [];

  QuizQuestionCubit(
    int sectionId,
    BuildContext context, {
    required this.gameId,
    QuizQuestionRepository? repository,
  }) : _repository = repository ?? QuizQuestionRepository(),
       super(QuizQuestionState.initial()) {
    maxQuestions = switch (gameId) {
      "trivia" => 5,
      "aircraftEncyclopaedia" => 10,
      "imageBased" => 10,
      _ => 20,
    };

    const gameDurations = {"quiz": 180, "calculation": 40, "one_word": 40};
    _quizTypesId = sectionId;
    _totalDuration = gameDurations[gameId] ?? 40;
    loadQuestions(sectionId, context);
  }

  String returnGameName() {
    switch (gameId) {
      case "calculation":
        return "Calculation Game";
      case "one_word":
        return "Basic Topics Game";
      case "trivia":
        return "Jetting Around The World Game";
      case "imageBased":
        return "PlaneSpotter Game";
      case "aircraftEncyclopaedia":
        return "Citius. Altius. Longius. Game";
      default:
        return "Quiz Game";
    }
  }

  Future<void> loadQuestions(int sectionId, BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
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
        } else if (gameId == "aircraftEncyclopaedia") {
          gameData = await _repository.getAircraftEncyclopaediaQuestionData(3);
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
          AppSnackBar.custom(
            context,
            message:
                'No questions available at this time. Please wait while more questions are loading. Try again later.',
            svgAsset: '',
          );
          Future.delayed(const Duration(seconds: 4), () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
          return;
        }

        // Map initial questions by category name
        final Map<String, List<QuizQuestion>> categorizedQuestions = {};
        for (var category in gameData.categoryTypes) {
          var questions = category.questions
              .map(
                (q) => _mapQuestion(q, gameData!.setId, gameData.imageBasedId),
              )
              .toList();
          categorizedQuestions[category.name] = questions;
        }

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
              errorMessage: 'No questions could be mapped',
            ),
          );
          return;
        }

        final initialResults = List<QuestionResult>.generate(
          maxQuestions,
          (index) => QuestionResult(
            userAnswerIndex: null,
            correctPoint: 0,
            bonusPoint: 0,
            timeTakenSeconds: 0,
          ),
        );

        emit(
          state.copyWith(
            isLoading: false,
            questions: allQuestions,
            allTempQuestions: allQuestions,
            gameTempData: gameData,
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
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadQuestions(sectionId, context),
      );
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

  Future<void> _fetchAndBufferBackgroundQuestions(
    int sectionId,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      for (int actionNumber = 1; actionNumber <= 2; actionNumber++) {
        if (state.questions.length + _bufferedQuestions.length >=
            maxQuestions) {
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
            errorMessage: 'No questions available.',
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => _fetchAndBufferBackgroundQuestions(sectionId, context),
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
      "Current Quesiton correctIndex:- ${state.currentQuestion.correctIndex}      Current Quesiton Image Url:- ${state.currentQuestion.imgUrl}",
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

    int updatedWrongStreak = isCorrect ? 0 : state.consecutiveWrongAnswers + 1;

    bool shouldShowWrongPopup =
        updatedWrongStreak == 3 && state.currentIndex < maxQuestions - 1;

    int timeBonus = isCorrect && state.timer >= _totalDuration / 2 ? 1 : 0;

    int pointsThisQuestion = isCorrect ? 2 : 0;
    int bonusPointsThisQuestion = timeBonus;

    final timeSpentThisQuestion = max(1, _totalDuration - state.timer);
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

        consecutiveWrongAnswers: shouldShowWrongPopup ? 0 : updatedWrongStreak,

        wrongAnswerPopupCount: shouldShowWrongPopup
            ? (state.wrongAnswerPopupCount % 3) + 1
            : state.wrongAnswerPopupCount,

        showWrongAnswerPopup: shouldShowWrongPopup,
      ),
    );
  }

  Future<void> nextQuestion(BuildContext context) async {
    if (state.currentIndex + 1 < state.questions.length) {
      final count = await SharedPrefsHelper.getJettingGamesCount();
      final isAlreadyPressed =
          await SharedPrefsHelper.getIsAlreadyShowPopup() ?? false;

      if (gameId == "trivia" &&
          state.currentIndex == 1 &&
          count == 2 &&
          !isAlreadyPressed) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AviationChroniclePopup(
            onButtonTap: () async {
              Navigator.of(context).pop();
              await SharedPrefsHelper.saveIsAlreadyShowPopup(true);
              await _moveToNextQuestion(context);
            },
            onCancelButtonTap: () async {
              Navigator.of(context).pop();
              await SharedPrefsHelper.saveIsAlreadyShowPopup(true);
              await _moveToNextQuestion(context);
            },
          ),
        );
      } else {
        await _moveToNextQuestion(context);
      }
    } else if (state.currentIndex == maxQuestions - 1) {
      _timer?.cancel();

      if (gameId == "trivia") {
        await _showTriviaResultPopup(context);
      } else {
        await _submitQuizResult(context);
      }
    } else if (state.isLoading) {
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

  // -----------------------------------------------------------------------------
  // MOVE TO NEXT QUESTION
  // -----------------------------------------------------------------------------

  Future<void> _moveToNextQuestion(BuildContext context) async {
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

  // -----------------------------------------------------------------------------
  // EMPTY QUESTION RESULT
  // -----------------------------------------------------------------------------

  QuestionResult _emptyQuestionResult() {
    return QuestionResult(
      userAnswerIndex: null,
      correctPoint: 0,
      bonusPoint: 0,
      timeTakenSeconds: 0,
    );
  }

  // -----------------------------------------------------------------------------
  // FORMAT TIME
  // -----------------------------------------------------------------------------

  String _formatTime(int seconds) {
    return "${seconds}s";
  }

  // -----------------------------------------------------------------------------
  // INDEX TO LETTER
  // -----------------------------------------------------------------------------

  String _indexToLetter(int? index) {
    if (index == null) return "";
    return String.fromCharCode(65 + index);
  }

  // -----------------------------------------------------------------------------
  // RESET QUESTION STATE
  // -----------------------------------------------------------------------------

  void _resetQuestionState() {
    emit(
      state.copyWith(
        currentIndex: 0,
        selectedIndex: null,
        showAnswer: false,
        timer: _totalDuration,
        isTimerEnded: false,
      ),
    );
  }

  // -----------------------------------------------------------------------------
  // INITIAL QUESTION RESULTS
  // -----------------------------------------------------------------------------

  List<QuestionResult> _createInitialQuestionResults() {
    return List<QuestionResult>.generate(
      maxQuestions,
      (index) => _emptyQuestionResult(),
    );
  }

  // -----------------------------------------------------------------------------
  // BUILD CATEGORIES
  // -----------------------------------------------------------------------------

  List<Map<String, dynamic>> _buildCategories() {
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
        "questions": questions.map((q) {
          final resultIndex = state.questions.indexOf(q);

          final result = resultIndex != -1
              ? state.questionResults[resultIndex]
              : _emptyQuestionResult();

          return {
            "question": q.question,
            "options": List.generate(
              q.options.length,
              (optIndex) => {
                "label": String.fromCharCode(65 + optIndex),
                "value": q.options[optIndex],
              },
            ),
            "answer": _indexToLetter(q.correctIndex),
            "explanation": q.hint,
            "img_url": q.imgUrl,
            "user_answered": _indexToLetter(result.userAnswerIndex),
            "correct_point": result.correctPoint,
            "bonus_point": result.bonusPoint,
            "time_taken": _formatTime(result.timeTakenSeconds),
          };
        }).toList(),
      };
    }).toList();

    return categories;
  }

  // -----------------------------------------------------------------------------
  // BUILD RESULT PAYLOAD
  // -----------------------------------------------------------------------------

  Map<String, dynamic> _buildResultPayload() {
    final allCorrectBonus = state.correctAnswers == maxQuestions ? 3 : 0;

    final finalScore = state.score + allCorrectBonus;

    return {
      "total_questions": maxQuestions,
      "correct_answers": state.correctAnswers,
      "correct_points": state.pointsEarned,
      "earned_points": finalScore,
      "additional_points": state.bonusPoints,
      "total_time": _formatTime(state.timeTaken),
      "game": state.game,
      "level": state.level,
      "difficulty": state.difficulty,
      "categories": _buildCategories(),
      "game_number": _quizTypesId,
      "set_id": gameId == "imageBased" ? state.imageBasedId : state.setId,
      "img_id": state.imageBasedId,
    };
  }

  // -----------------------------------------------------------------------------
  // TRIVIA RESULT POPUP
  // -----------------------------------------------------------------------------

  Future<void> _showTriviaResultPopup(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => JettingAroundResultPopup(
        isSuccess: state.correctAnswers < 4 ? false : true,
        currentStep: state.correctAnswers,
        totalStep: 5,
        earnedJettons: 200,
        onCrossButtonTap: () async {
          Navigator.of(context).pop();
          if (state.correctAnswers < 4) {
            await _restartTrivia(context);
          } else {
            await _handleSuccessfulTrivia(context);
          }
        },
        onButtonTap: () async {
          Navigator.of(context).pop();
          if (state.correctAnswers < 4) {
            await _restartTrivia(context);
          } else {
            await _handleSuccessfulTrivia(context);
          }
        },
      ),
    );
  }

  // -----------------------------------------------------------------------------
  // RESTART TRIVIA
  // -----------------------------------------------------------------------------

  Future<void> _restartTrivia(BuildContext context) async {
    _resetQuestionState();

    final initialResults = _createInitialQuestionResults();

    emit(
      state.copyWith(
        isLoading: false,
        questions: state.allTempQuestions,
        allTempQuestions: state.allTempQuestions,
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
        categorizedQuestions: state.categorizedQuestions,
        game: state.gameTempData!.game,
        level: state.gameTempData!.level,
        difficulty: state.gameTempData!.difficulty,
        categoryTypes: state.gameTempData!.categoryTypes,
        setId: state.gameTempData!.setId,
        imageBasedId: state.gameTempData!.imageBasedId,
      ),
    );

    startTimer(context);
  }

  // -----------------------------------------------------------------------------
  // SUCCESSFUL TRIVIA
  // -----------------------------------------------------------------------------

  Future<void> _handleSuccessfulTrivia(BuildContext context) async {
    final payload = _buildResultPayload();

    final count = await SharedPrefsHelper.getJettingGamesCount();

    if (count >= 4) {
      await _saveAndSubmitTriviaResult(context, payload);
    } else {
      await _saveTriviaResultLocally(context, payload);
    }
  }

  // -----------------------------------------------------------------------------
  // SAVE + SUBMIT TRIVIA RESULT
  // -----------------------------------------------------------------------------

  Future<void> _saveAndSubmitTriviaResult(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    final responseWait = await SharedPrefsHelper.saveJettingGame(payload);

    print('Save ModelWithId: $responseWait');

    final List<Map<String, dynamic>> allGames =
        await SharedPrefsHelper.getJettingGames();

    final Map<String, dynamic> updatedPayLoadWithDict = {"game": allGames};

    if (await InternetConnection().hasInternetAccess) {
      try {
        final response = await QuizQuestionRepository().submitResult(
          updatedPayLoadWithDict,
          gameId,
        );

        if (response.detail.toLowerCase() ==
            "quiz answer submitted successfully".toLowerCase()) {
          final data = response.data;

          Future.delayed(const Duration(milliseconds: 100), () async {
            // await SharedPrefsHelper.clearJettingGames();
            // Handle After Show All Button.

            AppNavigator.push(
              context,
              JettingAroundTheWorldScreen(
                isComeFromResultScreen: true,
                responseFromResultScreenData: response.data,
              ),
              multiBlocProviders: [
                BlocProvider(create: (_) => JettingTheWorldCubit()),
              ],
              disableSwipeBack: true,
            );

            AnalyticsService.instance.buttonPressed(
              FirebaseEvents.calculationsListButton,
              FirebaseEvents.calculationResultScreen,
            );
          });
        } else {
          SessionCommonTokenError.handleUnauthorizedError(context, e);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Result submit failed. Try again.")),
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
    } else {
      NoInternetDialog.show(context, onRetry: () => nextQuestion(context));
    }
  }

  // -----------------------------------------------------------------------------
  // SAVE TRIVIA RESULT LOCALLY
  // -----------------------------------------------------------------------------

  Future<void> _saveTriviaResultLocally(
    BuildContext context,
    Map<String, dynamic> payload,
  ) async {
    final responseWait = await SharedPrefsHelper.saveJettingGame(payload);

    print('Save ModelWithId: $responseWait');

    if (responseWait) {
      _resetQuestionState();
      loadQuestions(_quizTypesId, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit results.')),
      );

      emit(state.copyWith(errorMessage: 'Failed to submit results.'));
    }
  }

  // -----------------------------------------------------------------------------
  // SUBMIT QUIZ / IMAGE BASED RESULT
  // -----------------------------------------------------------------------------

  Future<void> _submitQuizResult(BuildContext context) async {
    final payload = _buildResultPayload();

    debugPrint("QUIZ SUBMIT PAYLOAD:");
    debugPrint(JsonEncoder.withIndent('  ').convert(payload));

    if (await InternetConnection().hasInternetAccess) {
      try {
        final response = await QuizQuestionRepository().submitResult(
          payload,
          gameId,
        );

        if (response.detail.toLowerCase() ==
            "quiz answer submitted successfully".toLowerCase()) {
          final data = response.data;

          Future.delayed(const Duration(milliseconds: 100), () {
            if (gameId == "imageBased") {
              _showImageBasedResult(context, data);
            } else {
              _showMainResult(context, data);
            }
          });
        } else {
          SessionCommonTokenError.handleUnauthorizedError(context, e);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Result submit failed. Try again.")),
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
    } else {
      NoInternetDialog.show(context, onRetry: () => nextQuestion(context));
    }
  }

  // -----------------------------------------------------------------------------
  // IMAGE BASED RESULT
  // -----------------------------------------------------------------------------

  void _showImageBasedResult(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return ImageBasedResultDialog(
          correctAnswers: data.correctAnswers,
          totalQuestions: data.totalQuestions,
          componentEarned: data.componentEarned,
          componentTitle: data.component?.name ?? '',
          componentDescription: data.component?.description ?? '',
          onContinue: () {
            if (data.partUnlock && data.part != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ComponentUnlockedScreen(
                    partName: data.part!.name,
                    image3d: data.part!.icon,
                    onView3DPart: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AirplanePartsScreen(isFromGame: true),
                        ),
                      );
                      if (result == true && context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    onNext: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  // -----------------------------------------------------------------------------
  // MAIN RESULT
  // -----------------------------------------------------------------------------

  void _showMainResult(BuildContext context, dynamic data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainResultScreen(
          correctedAnswer: data.correctAnswers,
          totalQuestion: data.totalQuestions,
          score: data.earnedPoints,
          bonusPoints: data.additionalPoints,
          isEarnedBadge: data.isEarnedBadge,
          badgeName: data.badgeName,
          isComeFromTrivia: false,
        ),
      ),
    );

    AnalyticsService.instance.buttonPressed(
      FirebaseEvents.calculationsListButton,
      FirebaseEvents.calculationResultScreen,
    );
  }

  String formatCategoryName(String name) {
    return name
        .split('_')
        .map((word) => word[0].toLowerCase() + word.substring(1))
        .join(' ');
  }

  void continueAfterWrongPopup(BuildContext context) {
    emit(state.copyWith(showWrongAnswerPopup: false));

    nextQuestion(context);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
