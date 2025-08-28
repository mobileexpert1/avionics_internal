// import 'dart:async';
// import 'dart:convert';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_repository.dart';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_result_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
// import '../../../Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';
// import '../SubGameSection/Calculation_Section/calculation_model.dart';
//
// class QuizQuestionCubit extends Cubit<QuizQuestionState> {
//   Timer? _timer;
//   final QuizQuestionRepository _repository;
//   static const int maxQuestions = 20;
//
//   QuizQuestionCubit(int sectionId, BuildContext context, {QuizQuestionRepository? repository})
//       : _repository = repository ?? QuizQuestionRepository(),
//         super(QuizQuestionState.initial()) {
//     loadQuestions(sectionId, context);
//   }
//
//   Future<void> loadQuestions(int sectionId, BuildContext context) async {
//     try {
//       emit(state.copyWith(isLoading: true));
//
//       final calculationData = await _repository.getCalculationData(sectionId,1);
//
//       if (calculationData == null) {
//         emit(
//           state.copyWith(
//             isLoading: false,
//             errorMessage: 'No internet or no data',
//           ),
//         );
//         return;
//       }
//
//       // Map initial questions by category
//       final Map<String, List<QuizQuestion>> categorizedQuestions = {};
//       for (var category in calculationData.categoryTypes) {
//         categorizedQuestions[category.type] = category.questions
//             .map((q) => QuizQuestion(
//           question: q.question,
//           options: q.options.map((o) => o.value).toList(),
//           correctIndex: q.options.indexWhere((o) => o.label == q.answer),
//           hint: q.explanation,
//         ))
//             .toList();
//       }
//
//       // Combine initial questions for quiz progression, capped at maxQuestions
//       final allQuestions = calculationData.categoryTypes
//           .expand((category) => category.questions)
//           .map((q) => QuizQuestion(
//         question: q.question,
//         options: q.options.map((o) => o.value).toList(),
//         correctIndex: q.options.indexWhere((o) => o.label == q.answer),
//         hint: q.explanation,
//       ))
//           .take(maxQuestions)
//           .toList();
//
//       // Initialize results and timePerQuestion for maxQuestions
//       final initialResults = List<QuestionResult>.generate(
//         maxQuestions,
//             (index) => QuestionResult(
//           userAnswerIndex: null,
//           correctPoint: 0,
//           bonusPoint: 0,
//           timeTakenSeconds: 0,
//         ),
//       );
//
//       // Update state with initial questions, start timer, keep isLoading true
//       emit(
//         state.copyWith(
//           isLoading: false, // Keep loading until 20 questions or background fetches complete
//           questions: allQuestions,
//           currentIndex: 0,
//           selectedIndex: null,
//           showAnswer: false,
//           timer: 40,
//           score: 0,
//           correctAnswers: 0,
//           wrongAnswers: 0,
//           pointsEarned: 0,
//           bonusPoints: 0,
//           timeTaken: 0,
//           questionResults: initialResults,
//           timePerQuestion: List<int>.filled(maxQuestions, 0),
//           categorizedQuestions: categorizedQuestions,
//         ),
//       );
//
//       // Start the timer to allow immediate quiz interaction
//       startTimer(context);
//
//       // Start background fetches if fewer than 20 questions
//       if (allQuestions.length < maxQuestions) {
//         _fetchAndAppendBackgroundQuestions(sectionId, context);
//       } else {
//         emit(state.copyWith(isLoading: false));
//       }
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }
//
//   Future<void> _fetchAndAppendBackgroundQuestions(int sectionId, BuildContext context) async {
//     for (int actionNumber = 2; actionNumber <= 3; actionNumber++) {
//       if (state.questions.length >= maxQuestions) {
//         break; // Stop if we have 20 questions
//       }
//       final additionalData = await _repository.fetchAdditionalQuestions(sectionId, actionNumber);
//       if (additionalData != null) {
//         await appendQuestions(additionalData);
//       }
//     }
//
//     // Stop loading after all background fetches complete or 20 questions reached
//     emit(state.copyWith(isLoading: false));
//   }
//
//   Future<void> appendQuestions(CalculationGameModel additionalData) async {
//     if (state.questions.length >= maxQuestions) {
//       return; // No need to append if already at max
//     }
//
//     // Map new questions by category
//     final Map<String, List<QuizQuestion>> newCategorizedQuestions = {};
//     for (var category in additionalData.categoryTypes) {
//       newCategorizedQuestions[category.type] = category.questions
//           .map((q) => QuizQuestion(
//         question: q.question,
//         options: q.options.map((o) => o.value).toList(),
//         correctIndex: q.options.indexWhere((o) => o.label == q.answer),
//         hint: q.explanation,
//       ))
//           .toList();
//     }
//
//     // Merge with existing categorized questions
//     final updatedCategorizedQuestions = Map<String, List<QuizQuestion>>.from(state.categorizedQuestions);
//     newCategorizedQuestions.forEach((type, newQuestions) {
//       updatedCategorizedQuestions.update(
//         type,
//             (existing) => [...existing, ...newQuestions].take(maxQuestions).toList(),
//         ifAbsent: () => newQuestions.take(maxQuestions).toList(),
//       );
//     });
//
//     // Combine new questions, capped at remaining capacity
//     final newQuestions = additionalData.categoryTypes
//         .expand((category) => category.questions)
//         .map((q) => QuizQuestion(
//       question: q.question,
//       options: q.options.map((o) => o.value).toList(),
//       correctIndex: q.options.indexWhere((o) => o.label == q.answer),
//       hint: q.explanation,
//     ))
//         .take(maxQuestions - state.questions.length)
//         .toList();
//
//     // Append to existing questions
//     final updatedQuestions = [...state.questions, ...newQuestions].take(maxQuestions).toList();
//
//     // Update state only if new questions were added
//     if (newQuestions.isNotEmpty) {
//       emit(
//         state.copyWith(
//           questions: updatedQuestions,
//           categorizedQuestions: updatedCategorizedQuestions,
//         ),
//       );
//     }
//   }
//
//   DateTime? _startTime;
//   final int _totalDuration = 40;
//
//   void startTimer(BuildContext context) {
//     _startTime = DateTime.now();
//     emit(state.copyWith(timer: _totalDuration));
//     _timer?.cancel();
//     print("Timer Start");
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       final elapsed = DateTime.now().difference(_startTime!).inSeconds;
//       final remaining = _totalDuration - elapsed;
//
//       if (remaining >= 0) {
//         emit(
//           state.copyWith(
//             timer: remaining,
//             selectedIndex: state.selectedIndex,
//           ),
//         );
//         // print("Pending time $remaining");
//       } else {
//         print("Time out");
//         _timer?.cancel();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Times Up')),
//         );
//
//         Future.delayed(const Duration(seconds: 2), () {
//           emit(state.copyWith(
//             showAnswer: true,
//             isTimerEnded: true,
//             selectedIndex: state.currentQuestion.correctIndex,
//           ));
//         });
//       }
//     });
//   }
//
//   void selectOption(int index) {
//     emit(state.copyWith(selectedIndex: index, showAnswer: false));
//   }
//
//   void submitQuestion(BuildContext context) {
//     _timer?.cancel();
//
//     final isCorrect = state.selectedIndex == state.currentQuestion.correctIndex;
//     int timeBonus = isCorrect && state.timer >= 20 ? 1 : 0;
//
//     int pointsThisQuestion = isCorrect ? 2 : 0;
//     int bonusPointsThisQuestion = timeBonus;
//
//     final timeSpentThisQuestion = 40 - state.timer;
//     final updatedResults = List<QuestionResult>.from(state.questionResults);
//     final updatedTimePerQuestion = List<int>.from(state.timePerQuestion);
//
//     updatedResults[state.currentIndex] = QuestionResult(
//       userAnswerIndex: state.selectedIndex,
//       correctPoint: pointsThisQuestion,
//       bonusPoint: bonusPointsThisQuestion,
//       timeTakenSeconds: timeSpentThisQuestion,
//     );
//     updatedTimePerQuestion[state.currentIndex] = timeSpentThisQuestion;
//
//     final newPointsEarned = state.pointsEarned + pointsThisQuestion;
//     final newBonusPoints = state.bonusPoints + bonusPointsThisQuestion;
//     final newScore = state.score + pointsThisQuestion + bonusPointsThisQuestion;
//     final newTimeTaken = state.timeTaken + timeSpentThisQuestion;
//
//     emit(
//       state.copyWith(
//         questionResults: updatedResults,
//         timePerQuestion: updatedTimePerQuestion,
//         selectedIndex: state.selectedIndex,
//         showAnswer: true,
//         correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
//         wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
//         score: newScore,
//         pointsEarned: newPointsEarned,
//         bonusPoints: newBonusPoints,
//         timeTaken: newTimeTaken,
//         isTimerEnded: true,
//         totalBonusPoints: state.totalBonusPoints + timeBonus,
//       ),
//     );
//   }
//
//   Future<void> nextQuestion(BuildContext context) async {
//     final isLast = state.currentIndex == maxQuestions - 1;
//
//     if (!isLast) {
//       emit(
//         state.copyWith(
//           currentIndex: state.currentIndex + 1,
//           selectedIndex: null,
//           showAnswer: false,
//           timer: 40,
//           isTimerEnded: false,
//         ),
//       );
//       startTimer(context);
//     } else if (!state.isLoading && state.questions.length >= maxQuestions) {
//       // Only navigate to result screen if background fetches are complete and 20 questions are loaded
//       _timer?.cancel();
//
//       String formatTime(int seconds) {
//         return "${seconds}s";
//       }
//
//       String indexToLetter(int? index) {
//         if (index == null) return "";
//         return String.fromCharCode(65 + index); // 65 = 'A'
//       }
//
//       // Build category-specific question results
//       buildCategoryQuestions(List<QuizQuestion> questions, String categoryType) {
//         return questions.map((q) {
//           final resultIndex = state.questions.indexOf(q);
//           return {
//             "question": q.question,
//             "options": List.generate(q.options.length, (optIndex) {
//               return {
//                 "label": String.fromCharCode(65 + optIndex),
//                 "value": q.options[optIndex],
//               };
//             }),
//             "answer": indexToLetter(q.correctIndex),
//             "explanation": q.hint,
//             "user_answered": indexToLetter(state.questionResults[resultIndex].userAnswerIndex),
//             "correct_point": state.questionResults[resultIndex].correctPoint,
//             "bonus_point": state.questionResults[resultIndex].bonusPoint,
//             "time_taken": formatTime(state.questionResults[resultIndex].timeTakenSeconds),
//           };
//         }).toList();
//       }
//
//       // Build payload with categorized questions
//       final data = state.categorizedQuestions.map((categoryType, questions) {
//         return MapEntry(categoryType, buildCategoryQuestions(questions, categoryType));
//       });
//
//       // Final totals
//       final allCorrectBonus = (state.correctAnswers == maxQuestions) ? 3 : 0;
//       final finalScore = state.score + allCorrectBonus;
//
//       // Build payload
//       final payload = {
//         "total_questions": maxQuestions,
//         "correct_answers": state.correctAnswers,
//         "correct_points": state.pointsEarned,
//         "earned_points": finalScore,
//         "additional_points": state.bonusPoints,
//         "total_time": formatTime(state.timeTaken),
//         "data": data,
//       };
//
//       void debugPrintFull(dynamic data) {
//         const int chunkSize = 800;
//         final jsonStr = jsonEncode(data);
//         for (var i = 0; i < jsonStr.length; i += chunkSize) {
//           debugPrint(jsonStr.substring(i, i + chunkSize > jsonStr.length ? jsonStr.length : i + chunkSize));
//         }
//       }
//
//       debugPrintFull(payload);
//
//       // try {
//       //   await _repository.submitCalculationResult(payload);
//       // } catch (e) {
//       //   print("Submit API failed: $e");
//       // }
//
//       final percent = (state.correctAnswers / maxQuestions) * 100;
//       final winAchieved = percent >= 80;
//
//       Future.delayed(const Duration(milliseconds: 100), () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CalculationResultScreen(
//               correctedAnswer: state.correctAnswers,
//               totalQuestion: maxQuestions,
//               score: finalScore,
//               winAchieved: winAchieved,
//               bonusPoints: state.bonusPoints,
//             ),
//           ),
//         );
//       });
//     } else {
//       // If isLoading is true or fewer than 20 questions, show a message to wait
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please wait, more questions are loading...')),
//       );
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_repository.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import '../../../Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';
import '../SubGameSection/Calculation_Section/calculation_model.dart';

class QuizQuestionCubit extends Cubit<QuizQuestionState> {
  Timer? _timer;
  final QuizQuestionRepository _repository;
  static const int maxQuestions = 20;

 bool isNoMoreQuestionArrived = false;
  final String gameId;

  QuizQuestionCubit(
    int sectionId,
    BuildContext context, {
        required this.gameId,
        QuizQuestionRepository? repository,

  }) : _repository = repository ?? QuizQuestionRepository(),
       super(QuizQuestionState.initial()) {
    loadQuestions(sectionId, context);
  }

  // QuizQuestion _mapQuestion(dynamic q) {
  //   return QuizQuestion(
  //     question: q.question,
  //     options: q.options.map((o) => o.value).toList().cast<String>(),
  //     correctIndex: q.options.indexWhere((o) => o.label == q.answer),
  //     hint: q.explanation,
  //   );
  // }

  QuizQuestion _mapQuestion(Question q) {
    final correctIndex = q.options.indexWhere((o) => o.label == q.answer);
    print('Mapping question: ${q.question}, options: ${q.options.length}, answer: ${q.answer}, correctIndex: $correctIndex');
    if (correctIndex == -1) {
      print('Warning: No matching answer for question "${q.question}", answer: ${q.answer}');
    }
    return QuizQuestion(
      question: q.question,
      options: q.options.map((o) => o.value).toList(),
      correctIndex: correctIndex,
      hint: q.explanation,
    );
  }

  // Local buffer for silent background questions SD
  List<QuizQuestion> _bufferedQuestions = [];

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
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid gameId: $gameId',
        ));
        return;
      }

      print('Raw gameData: $gameData');

      if (gameData == null || gameData.categoryTypes.isEmpty) {
        print('No categories found in gameData');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No questions available from API',
        ));
        return;
      }

      // Map initial questions by category name
      final Map<String, List<QuizQuestion>> categorizedQuestions = {};
      for (var category in gameData.categoryTypes) {
        var questions = category.questions.map(_mapQuestion).toList();
        print('Category: ${category.name}, Questions: Queens ${questions.length}');
        categorizedQuestions[category.name] = questions;
      }

      // Initial questions capped at maxQuestions
      final allQuestions = gameData.categoryTypes
          .expand((category) => category.questions)
          .map(_mapQuestion)
          .take(maxQuestions)
          .toList();

      print('Total questions mapped: ${allQuestions.length}');

      if (allQuestions.isEmpty) {
        print('No questions mapped from categories');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No questions could be mapped from API response',
        ));
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
          timer: 40,
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
        ),
      );

      print('State updated: questions=${state.questions.length}, currentIndex=${state.currentIndex}');

      // Start timer
      startTimer(context);

      // Fetch silently in background if needed
      if (allQuestions.length < maxQuestions) {
        _fetchAndBufferBackgroundQuestions(sectionId, context);
      }
    } catch (e, stackTrace) {
      print('Error loading questions: $e, StackTrace: $stackTrace');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load questions: $e',
      ));
    }
  }

  //
  // Future<void> _fetchAndBufferBackgroundQuestions(int sectionId,BuildContext context) async {
  //   for (int actionNumber = 1; actionNumber <= 2; actionNumber++) {
  //     if (state.questions.length + _bufferedQuestions.length >= maxQuestions) {
  //       break;
  //     }
  //     final additionalData = await _repository.fetchAdditionalQuestions(
  //       sectionId,
  //       actionNumber,
  //     );
  //     if (additionalData != null) {
  //       await appendQuestionsSilently(additionalData,context);
  //     }
  //   }
  // }


  Future<void> _fetchAndBufferBackgroundQuestions(int sectionId, BuildContext context) async {
    print('Fetching background questions for sectionId: $sectionId');
    for (int actionNumber = 1; actionNumber <= 2; actionNumber++) {
      if (state.questions.length + _bufferedQuestions.length >= maxQuestions) {
        print('Max questions reached: ${state.questions.length + _bufferedQuestions.length}');
        break;
      }
      CalculationGameModel? additionalData;
      if (gameId == "calculation") {
        additionalData = await _repository.fetchAdditionalQuestions(sectionId, actionNumber);
      } else if (gameId == "one_word") {
        additionalData = await _repository.fetchOneWordQuestions(sectionId, actionNumber);
      }
      else if (gameId == "quiz") {
        additionalData = await _repository.fetchQuizQuestions(sectionId, actionNumber);
      } else {
        print('Invalid gameId for background fetch: $gameId');
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid gameId for background fetch: $gameId',
        ));
        return;
      }
      print('Additional data for action $actionNumber: $additionalData');
      if (additionalData != null && additionalData.categoryTypes.isNotEmpty) {
        await appendQuestionsSilently(additionalData, context);
      } else {
        print('No additional questions for action $actionNumber');
      }
    }
    if (state.questions.length + _bufferedQuestions.length == 0) {
      print('No questions after background fetch');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'No questions available after background fetch.',
      ));
    }
  }




  Future<void> appendQuestionsSilently(
    CalculationGameModel additionalData,
      BuildContext context
  ) async {
    if (state.questions.length + _bufferedQuestions.length >= maxQuestions) {
      return;
    }

    final newQuestions = additionalData.categoryTypes
        .expand((category) => category.questions)
        .map(_mapQuestion)
        .take(
          maxQuestions - (state.questions.length + _bufferedQuestions.length),
        )
        .toList()
        .cast<QuizQuestion>();

    if (newQuestions.isNotEmpty) {
      _bufferedQuestions.addAll(newQuestions);
      if (isNoMoreQuestionArrived == true ) {
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

    if (isNoMoreQuestionArrived == true ) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All set! Taking you to the next question...')));
      Future.delayed(const Duration(seconds: 4), () {
        isNoMoreQuestionArrived = false;
        nextQuestion(context);
      });
    }
  }

  DateTime? _startTime;
  final int _totalDuration = 40;

  void startTimer(BuildContext context) {
    _startTime = DateTime.now();
    emit(state.copyWith(timer: _totalDuration));
    _timer?.cancel();
    // print("Timer Start");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final remaining = _totalDuration - elapsed;

      if (remaining >= 0) {
        emit(
          state.copyWith(timer: remaining, selectedIndex: state.selectedIndex),
        );
        print("Pending time $remaining");
      } else {
        // print("Time out");
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

  void selectOption(int index) {
    emit(state.copyWith(selectedIndex: index, showAnswer: false));
  }

  Future<void> submitQuestion(BuildContext context) async {
    _timer?.cancel();

    final isCorrect = state.selectedIndex == state.currentQuestion.correctIndex;
    int timeBonus = isCorrect && state.timer >= 20 ? 1 : 0;

    int pointsThisQuestion = isCorrect ? 2 : 0;
    int bonusPointsThisQuestion = timeBonus;

    final timeSpentThisQuestion = max(1, 40 - state.timer); // Ensure minimum 1s
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
          timer: 40,
          isTimerEnded: false,
        ),
      );
      startTimer(context);

      print(state.currentIndex);
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
        final categoryName = entry.key; // category.name
        final questions = entry.value
            .where((q) => state.questions.contains(q))
            .toList();
        final categoryType =
            categoryTypeMap[categoryName] ??
            categoryName; // Use numeric type or fallback
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
      };
      // //
      // void debugPrintFull(dynamic data) {
      //   const int chunkSize = 800;
      //   final jsonStr = jsonEncode(data);
      //   for (var i = 0; i < jsonStr.length; i += chunkSize) {
      //     debugPrint(jsonStr.substring(
      //         i, i + chunkSize > jsonStr.length ? jsonStr.length : i + chunkSize));
      //   }
      // }
      //
      // debugPrintFull(payload);
      try {
        await QuizQuestionRepository().submitResult(payload, gameId);
      } catch (e) {
        print("Submit API failed: $e");
      }
      // Navigate to result screen
      final percent = (state.correctAnswers / maxQuestions) * 100;
      final winAchieved = percent >= 80;

      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CalculationResultScreen(
              correctedAnswer: state.correctAnswers,
              totalQuestion: maxQuestions,
              score: finalScore,
              winAchieved: winAchieved,
              bonusPoints: state.bonusPoints,
            ),
          ),
        );
      });
    }
    // If loading more
    else if (state.isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait, more questions are loading...'),
        ),
      );
    }
    // If fewer than maxQuestions
    else {
      isNoMoreQuestionArrived = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please hold on while we load the next set of questions…')),
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
