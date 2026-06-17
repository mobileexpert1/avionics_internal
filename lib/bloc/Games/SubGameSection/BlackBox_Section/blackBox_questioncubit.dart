import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../Helpers/NoInternetDialog.dart';
import '../../../../Screens/Games/GamesSubScreens/BlackBoxSection/BlackBoxResultScreen.dart';
import '../../QuizQuestionScreen/quiz_question_repository.dart';
import 'blackBox_question_model.dart';
import 'blackBox_repository.dart';
import 'blackBox_state.dart';

class BlackBoxQuestionCubit extends Cubit<BlackBoxState> {
  Timer? _timer;
  final BlackboxRepository _repository;
  final String gameId;
  final String questionNo;
  int _totalDuration = 60;
  DateTime? _startTime;
  bool? selectedAnswer;
  bool showAnswer = false;

  BlackBoxQuestionCubit(
    BuildContext context, {
    required this.gameId,
    required this.questionNo,
    BlackboxRepository? repository,
  }) : _repository = repository ?? BlackboxRepository(),
       super(BlackBoxState()) {
    const gameDurations = {"blackbox": 60};
    _totalDuration = gameDurations[gameId] ?? 60;
    loadQuestions(context, questionNo);
  }

  Future<void> reportQuestionPostMethod(
    String reason,
    BlackBoxQuestionCubit quizCubit,
    BuildContext context,
    String isForType,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final currentQuestion = quizCubit.state.currentQuestion;

        print(
          "setId:- ${quizCubit.state.questionSetId}, "
          "questionId:- ${currentQuestion.questionId}"
          "question:- ${currentQuestion.question}, "
          "reason:- $reason",
        );

        await QuizQuestionRepository().reportQuestionPostMethod(
          setId: quizCubit.state.questionSetId ?? "",
          questionId: currentQuestion.questionId ?? "",
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
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () =>
            reportQuestionPostMethod(reason, quizCubit, context, isForType),
      );
    }
  }

  BlackBoxQuestion _mapQuestion(
    Questions q,
    String categoryType, {
    String? name,
  }) {
    final type = categoryType.isNotEmpty ? categoryType : '3';

    int correctIndex = -1;
    List<int>? correctSequence;
    List<String>? sequenceItems;
    String? correctAnswer;
    List<int>? correctOptionList;

    if (type == '1') {
      if (q.answer != null && q.options != null && q.options!.isNotEmpty) {
        final answerLabels = q.answer!.split(',').map((e) => e.trim()).toList();
        sequenceItems = [];
        correctSequence = [];

        for (var label in answerLabels) {
          final index = q.options!.indexWhere((o) => o.label == label);
          if (index >= 0 && q.options![index].value != null) {
            sequenceItems.add(q.options![index].value!);
            correctSequence.add(index);
          } else {
            print(
              'Warning: Invalid option for label "$label" in question "${q.question}"',
            );
          }
        }

        if (sequenceItems.isEmpty || correctSequence.isEmpty) {
          print(
            'Warning: Empty sequence for event_sequence question "${q.question}"',
          );
          sequenceItems = null;
          correctSequence = null;
        }
      } else {
        print(
          'Warning: Missing answer or options for event_sequence question "${q.question}"',
        );
      }
    } else if (type == '2') {
      // True/False
      if (q.answer != null && q.options != null) {
        final answer = q.answer!.toLowerCase();
        if (answer == 'true' || answer == 'a') {
          correctIndex = q.options!.indexWhere(
            (o) => o.value?.toLowerCase() == 'true',
          );
          if (correctIndex == -1) correctIndex = 0;
        } else if (answer == 'false' || answer == 'b') {
          correctIndex = q.options!.indexWhere(
            (o) => o.value?.toLowerCase() == 'false',
          );
          if (correctIndex == -1) correctIndex = 1;
        }
        if (correctIndex == -1) {
          print(
            'Warning: Invalid answer for true_false question "${q.question}", answer: ${q.answer}',
          );
        }
      } else {
        print(
          'Warning: Missing answer or options for true_false question "${q.question}"',
        );
      }
    } else if (type == '3') {
      // Multiple choice
      if (q.answer != null && q.options != null) {
        correctIndex = q.options!.indexWhere((o) => o.label == q.answer);
        if (correctIndex == -1) {
          print(
            'Warning: No matching answer for question "${q.question}", answer: ${q.answer}',
          );
        }
      } else {
        print(
          'Warning: Missing answer or options for multiple_choice_question "${q.question}"',
        );
      }
    } else if (type == '4') {
      // Multiple correct answers
      if (q.answer != null && q.options != null && q.options!.isNotEmpty) {
        final answerLabels = q.answer!.split(',').map((e) => e.trim()).toList();
        correctOptionList = [];
        for (var label in answerLabels) {
          final index = q.options!.indexWhere((o) => o.label == label);
          if (index >= 0) {
            correctOptionList.add(index);
          } else {
            print(
              'Warning: Invalid label "$label" in multiple_correct question "${q.question}"',
            );
          }
        }

        if (correctOptionList.isEmpty) {
          correctOptionList = null;
        }
      } else {
        print(
          'Warning: Missing answer or options for multiple_correct question "${q.question}"',
        );
      }
    }

    return BlackBoxQuestion(
      question: q.question ?? '',
      options: q.options?.map((o) => o.value ?? '').toList() ?? [],
      correctIndex: correctIndex,
      hint: q.explanation ?? '',
      type: type,
      correctSequence: correctSequence,
      sequenceItems: sequenceItems,
      correctAnswer: correctAnswer,
      correctOptionList: correctOptionList,
      title: q.title ?? 'Question',
      name: name,
      questionId: q.questionId,
    );
  }

  Future<void> loadQuestions(BuildContext context, String questionNo) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        emit(state.copyWith(isLoading: true));
        final gameData = await _repository.getBlackBoxQuestions(questionNo);

        if (gameData == null ||
            gameData.categoryTypes == null ||
            gameData.categoryTypes!.isEmpty) {
          print('No categories found in gameData');
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'No questions available from API',
            ),
          );
          return;
        }

        final Map<String, List<BlackBoxQuestion>> categorizedQuestions = {};
        for (var category in gameData.categoryTypes!) {
          final List<BlackBoxQuestion>? mappedQuestions = category.questions
              ?.map(
                (q) =>
                    _mapQuestion(q, category.type ?? '3', name: category.name),
              )
              .toList();
          final List<BlackBoxQuestion> catQuestions =
              mappedQuestions ?? <BlackBoxQuestion>[];
          categorizedQuestions[category.type ?? 'Unknown'] = catQuestions;
        }

        final allowedTypes = ['1', '2', '3', '4'];
        final Iterable<BlackBoxQuestion> expandedQuestions = gameData
            .categoryTypes!
            .expand(
              (category) => (category.questions ?? <Questions>[]).map(
                (q) => _mapQuestion(q, category.type ?? '3'),
              ),
            );
        final List<BlackBoxQuestion> allQuestions = expandedQuestions.where((
          q,
        ) {
          final isValid =
              allowedTypes.contains(q.type) &&
              (q.type == '1'
                  ? q.sequenceItems != null && q.sequenceItems!.isNotEmpty
                  : true) &&
              (q.type == '2' || q.type == '3' || q.type == '4'
                  ? q.options.isNotEmpty
                  : true);
          if (!isValid) {
            print(
              'Filtered out question: ${q.question}, type: ${q.type}, valid: $isValid',
            );
          }
          return isValid;
        }).toList();

        final int totalQuestions = allQuestions.length;

        if (totalQuestions == 0) {
          print('No valid questions mapped from categories');
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'No valid questions found for allowed types',
            ),
          );
          return;
        }

        final initialResults = List<BlackBoxQuestionResult>.generate(
          totalQuestions,
          (index) => BlackBoxQuestionResult(
            userAnswerIndex: null,
            userSequence: null,
            userAnswer: null,
            correctPoint: 0,
            bonusPoint: 0,
            timeTakenSeconds: 0,
            selectedIndices: [],
          ),
        );

        emit(
          state.copyWith(
            isLoading: false,
            questions: allQuestions,
            currentIndex: 0,
            selectedIndex: null,
            selectedSequence: null,
            selectedAnswer: null,
            showAnswer: false,
            timer: _totalDuration,
            score: 0,
            correctAnswers: 0,
            wrongAnswers: 0,
            pointsEarned: 0,
            bonusPoints: 0,
            timeTaken: 0,
            questionResults: initialResults,
            timePerQuestion: List<int>.filled(totalQuestions, 0),
            categorizedQuestions: categorizedQuestions,
            game: gameData.game,
            level: gameData.level,
            difficulty: gameData.difficulty,
            questionSetId: gameData.questionSetId,
            categoryTypes: gameData.categoryTypes ?? <CategoryTypes>[],
            selectedIndices: [],
          ),
        );

        // Start timer
        startTimer(context);
      } catch (e, stackTrace) {
        print('Error loading questions: $e, StackTrace: $stackTrace');
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load questions: $e',
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => loadQuestions(context, questionNo),
      );
    }
  }

  void startTimer(BuildContext context) {
    _startTime = DateTime.now();
    emit(state.copyWith(timer: _totalDuration));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final remaining = _totalDuration - elapsed;

      if (remaining >= 0) {
        emit(
          state.copyWith(
            timer: remaining,
            selectedIndex: state.selectedIndex,
            selectedSequence: state.selectedSequence,
            selectedAnswer: state.selectedAnswer,
          ),
        );
      } else {
        _timer?.cancel();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Time\'s Up')));
        Future.delayed(const Duration(seconds: 2), () {
          emit(
            state.copyWith(
              showAnswer: true,
              isTimerEnded: true,
              timeTaken: 0,
              selectedIndex:
                  state.currentQuestion.type == '1' ||
                      state.currentQuestion.type == '4'
                  ? null
                  : state.currentQuestion.correctIndex,
              selectedSequence: state.currentQuestion.type == '1'
                  ? state.currentQuestion.correctSequence
                  : null,
              selectedAnswer: state.currentQuestion.type == '4'
                  ? state.currentQuestion.correctAnswer
                  : null,
            ),
          );
        });
      }
    });
  }

  void selectOption(int index) {
    emit(state.copyWith(selectedIndex: index, showAnswer: false));
  }

  void selectTrueFalse(int index) {
    emit(
      state.copyWith(
        selectedIndex: index,
        showAnswer: false,
        selectedAnswer: index.toString(),
      ),
    );
  }

  void updateSequence(List<String> newSequence) {
    final indices = newSequence.map((item) {
      final index = state.currentQuestion.options.indexWhere(
        (option) => option == item,
      );
      return index >= 0 ? index : 0;
    }).toList();

    emit(
      state.copyWith(
        selectedSequence: indices,
        selectedSequenceItems: newSequence,
        showAnswer: false,
      ),
    );
  }

  void toggleMultipleOption(int index, bool isSelected) {
    final updatedList = List<int>.from(state.selectedIndices ?? []);
    if (isSelected) {
      updatedList.add(index);
    } else {
      updatedList.remove(index);
    }
    emit(state.copyWith(selectedIndices: updatedList));
  }

  Future<void> submitQuestion(BuildContext context) async {
    _timer?.cancel();

    bool isCorrect = false;

    if (state.currentQuestion.type == '1') {
      final userSequence = state.selectedSequence ?? [];
      final correctSequence = state.currentQuestion.correctSequence ?? [];

      isCorrect =
          userSequence.length == correctSequence.length &&
          userSequence.asMap().entries.every(
            (entry) => entry.value == correctSequence[entry.key],
          );
    } else if (state.currentQuestion.type == '4') {
      final userSelected = state.selectedIndices ?? [];
      final correctIndices = state.currentQuestion.correctOptionList ?? [];

      isCorrect =
          userSelected.length == correctIndices.length &&
          userSelected.toSet().containsAll(correctIndices);
    } else {
      isCorrect = state.selectedIndex == state.currentQuestion.correctIndex;
    }
    int basePoints = 0;
    switch (state.currentQuestion.type) {
      case '1': // Sequence
        basePoints = 6;
        break;
      case '2': // True/False
        basePoints = 2;
        break;
      case '3': // Multiple Choice
        basePoints = 5;
        break;
      case '4': // Multiple Correct
        basePoints = 6;
        break;
      default:
        basePoints = 5;
        break;
    }

    int pointsThisQuestion = isCorrect ? basePoints : 0;
    int timeBonus = isCorrect && state.timer >= _totalDuration / 2 ? 1 : 0;
    int bonusPointsThisQuestion = timeBonus;
    final timeSpentThisQuestion = max(1, _totalDuration - state.timer);

    final updatedResults = List<BlackBoxQuestionResult>.from(
      state.questionResults,
    );
    final updatedTimePerQuestion = List<int>.from(state.timePerQuestion);

    updatedResults[state.currentIndex] = BlackBoxQuestionResult(
      userAnswerIndex:
          state.currentQuestion.type == '1' || state.currentQuestion.type == '4'
          ? null
          : state.selectedIndex,
      userSequence: state.currentQuestion.type == '1'
          ? state.selectedSequence
          : null,
      userAnswer: state.currentQuestion.type == '4'
          ? state.selectedAnswer
          : null,
      selectedIndices: state.currentQuestion.type == '4'
          ? state.selectedIndices
          : null,
      correctPoint: pointsThisQuestion,
      bonusPoint: bonusPointsThisQuestion,
      timeTakenSeconds: timeSpentThisQuestion,
    );

    updatedTimePerQuestion[state.currentIndex] = timeSpentThisQuestion;

    emit(
      state.copyWith(
        questionResults: updatedResults,
        timePerQuestion: updatedTimePerQuestion,
        selectedIndex:
            state.currentQuestion.type == '1' ||
                state.currentQuestion.type == '4'
            ? null
            : state.selectedIndex,
        selectedSequence: state.currentQuestion.type == '1'
            ? state.selectedSequence
            : null,
        selectedAnswer: state.currentQuestion.type == '4'
            ? state.selectedAnswer
            : null,
        showAnswer: true,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
        score: state.score + pointsThisQuestion + bonusPointsThisQuestion,
        pointsEarned: state.pointsEarned + pointsThisQuestion,
        bonusPoints: state.bonusPoints + bonusPointsThisQuestion,
        timeTaken: state.timeTaken + timeSpentThisQuestion,
        isTimerEnded: true,
        totalBonusPoints: state.totalBonusPoints + timeBonus,
      ),
    );
  }

  Future<void> nextQuestion(BuildContext context, int gameNumber) async {
    if (state.currentIndex + 1 < state.questions.length) {
      final nextQuestion = state.questions[state.currentIndex + 1];

      final shuffledSequenceItems =
          nextQuestion.type == '1' && nextQuestion.sequenceItems != null
          ? (List<String>.from(nextQuestion.sequenceItems!)..shuffle())
          : null;

      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          selectedIndex: null,
          selectedSequence: [],
          selectedAnswer: '',
          showAnswer: false,
          timer: _totalDuration,
          isTimerEnded: false,
          selectedSequenceItems: shuffledSequenceItems,
          selectedIndices: [],
        ),
      );
      startTimer(context);
    } else {
      _timer?.cancel();

      String formatTime(int seconds) => "${seconds}s";

      final categoryNameMap = {
        "1": "event sequence",
        "2": "true false",
        "3": "multiple choice question",
        "4": "multiple correct question",
      };

      final categories = state.categorizedQuestions.entries.map((entry) {
        final categoryKey = entry.key;
        final questions = entry.value;
        final categoryType = questions.isNotEmpty ? questions[0].type : '3';
        final categoryName = categoryNameMap[categoryKey] ?? categoryKey;

        print(categoryType.toString());

        return {
          "category_type": categoryType.toString(),
          "category_name": categoryName,
          "questions": questions.map((q) {
            int resultIndex = state.questions.indexWhere(
              (x) => x.question.trim() == q.question.trim(),
            );

            final result = resultIndex != -1
                ? state.questionResults[resultIndex]
                : BlackBoxQuestionResult(
                    userAnswerIndex: null,
                    userSequence: null,
                    userAnswer: null,
                    correctPoint: 0,
                    bonusPoint: 0,
                    timeTakenSeconds: 0,
                    selectedIndices: [],
                  );

            final options = List.generate(
              q.options.length,
              (i) => {
                "label": String.fromCharCode(65 + i),
                "value": q.options[i].toString().trim(),
              },
            );

            String answer = '';
            String userAnswered = '';

            switch (q.type) {
              case '1': // Sequence type
                final normalizedOpts = q.options
                    .map((o) => o.toString().trim())
                    .toList();
                answer =
                    q.sequenceItems
                        ?.map((v) {
                          final idx = normalizedOpts.indexWhere(
                            (o) => o == v.toString().trim(),
                          );
                          return idx != -1 ? String.fromCharCode(65 + idx) : '';
                        })
                        .where((l) => l.isNotEmpty)
                        .join(',') ??
                    '';
                if (result.userSequence != null &&
                    result.userSequence!.isNotEmpty) {
                  userAnswered = result.userSequence!
                      .map(
                        (i) => (i >= 0 && i < normalizedOpts.length)
                            ? String.fromCharCode(65 + i)
                            : '',
                      )
                      .where((l) => l.isNotEmpty)
                      .join(',');
                }
                break;

              case '4': // Multiple correct
                final normalizedOpts = q.options
                    .map((o) => o.toString().trim())
                    .toList();
                answer =
                    q.correctOptionList
                        ?.map(
                          (i) => (i >= 0 && i < normalizedOpts.length)
                              ? String.fromCharCode(65 + i)
                              : '',
                        )
                        .where((l) => l.isNotEmpty)
                        .join(',') ??
                    '';
                if (result.selectedIndices != null &&
                    result.selectedIndices!.isNotEmpty) {
                  userAnswered = result.selectedIndices!
                      .map(
                        (i) => (i >= 0 && i < normalizedOpts.length)
                            ? String.fromCharCode(65 + i)
                            : '',
                      )
                      .where((l) => l.isNotEmpty)
                      .join(',');
                }
                break;

              case '2':
              case '3':
              default:
                answer = q.correctIndex != null
                    ? String.fromCharCode(65 + q.correctIndex!)
                    : '';
                userAnswered = result.userAnswerIndex != null
                    ? String.fromCharCode(65 + result.userAnswerIndex!)
                    : '';
                break;
            }

            return {
              "question": q.question,
              "options": options,
              "answer": answer,
              "explanation": q.hint,
              "user_answered": userAnswered,
              "correct_point": result.correctPoint,
              "bonus_point": result.bonusPoint,
              "time_taken": formatTime(result.timeTakenSeconds),
            };
          }).toList(),
        };
      }).toList();

      final correctAnswers = state.questionResults.fold<int>(
        0,
        (sum, result) => sum + ((result.correctPoint) > 0 ? 1 : 0),
      );
      final correctPoints = state.questionResults.fold<int>(
        0,
        (sum, result) => sum + (result.correctPoint),
      );

      final bonusPoints = state.questionResults.fold<int>(
        0,
        (sum, result) => sum + (result.bonusPoint),
      );

      final allCorrectBonus = (correctAnswers == state.questions.length)
          ? 3
          : 0;
      final finalScore = correctPoints + bonusPoints + allCorrectBonus;

      final payload = {
        "total_questions": state.questions.length,
        "correct_answers": correctAnswers,
        "correct_points": correctPoints,
        "earned_points": finalScore,
        "additional_points": bonusPoints,
        "total_time": formatTime(state.timeTaken),
        "game": state.game,
        "set_id": state.questionSetId,
        "level": state.level,
        "difficulty": state.difficulty,
        "categories": categories,
      };

      debugPrint("🚀 QUIZ SUBMIT PAYLOAD:");
      debugPrint(JsonEncoder.withIndent('  ').convert(payload));
      if (await InternetConnection().hasInternetAccess) {
        try {
          await _repository.submitBlackBoxAnswers(payload, gameNumber);

          if (!context.mounted) return;

          final total = state.questions.length;
          final percent = total == 0 ? 0 : (correctAnswers / total) * 100;
          final winAchieved = percent >= 80;

          AnalyticsService.instance.buttonPressed(
            FirebaseEvents.blackBoxCalculationsListButton,
            FirebaseEvents.blackBoxCalculationResultScreen,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlackBoxResultScreen(
                correctedAnswer: correctAnswers,
                correctPoints: correctPoints,
                totalQuestion: total,
                score: finalScore,
                winAchieved: winAchieved,
                bonusPoints: bonusPoints,
              ),
            ),
          );
        } catch (e) {
          SessionCommonTokenError.handleUnauthorizedError(context, e);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit results'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        NoInternetDialog.show(
          context,
          onRetry: () => nextQuestion(context, gameNumber),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
