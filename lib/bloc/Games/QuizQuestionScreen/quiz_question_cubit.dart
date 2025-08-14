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
//
//   QuizQuestionCubit(int sectionId, BuildContext context)
//     : super(QuizQuestionState.initial()) {
//     loadQuestions(sectionId, context);
//   }
//
//   Future<void> loadQuestions(int sectionId, BuildContext context) async {
//     try {
//       emit(state.copyWith(isLoading: true));
//
//       final calculationData = await QuizQuestionRepository()
//           .getCalculationData();
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
//       final result = calculationData.result;
//
//       // Combine all categories into one big list
//       final allCategoryQuestions = [
//         ...result.altitudeConversionsMixedCalculations,
//         ...result.weightBalanceConversions,
//         ...result.distanceRangeConversions,
//         ...result.fuelVolumeFlowConversions,
//         ...result.pressureWeatherDataConversions,
//         ...result.speedTimeCalculations,
//         ...result.temperatureConversionsImpact,
//       ];
//
//       final questions = allCategoryQuestions
//           .map(
//             (q) => QuizQuestion(
//               question: q.question,
//               options: q.options.map((o) => o.value).toList(),
//               correctIndex: answerToIndex(q.answer),
//               hint: q.explanation,
//             ),
//           )
//           .toList();
//
//       final initialResults = List<QuestionResult>.generate(
//         questions.length,
//         (_) => QuestionResult(
//           userAnswerIndex: null,
//           correctPoint: 0,
//           bonusPoint: 0,
//           timeTakenSeconds: 0,
//         ),
//       );
//
//       emit(
//         state.copyWith(
//           isLoading: false,
//           questions: questions,
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
//         ),
//       );
//
//       // print('Emitted total questions count: ${questions.length}');
//       startTimer(context);
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
//     }
//   }
//
//   int answerToIndex(Answer answer) {
//     switch (answer) {
//       case Answer.A:
//         return 0;
//       case Answer.B:
//         return 1;
//       case Answer.C:
//         return 2;
//       case Answer.D:
//         return 3;
//     }
//   }
//
//   void startTimer(BuildContext context) {
//     _timer?.cancel();
//     emit(state.copyWith(timer: 40));
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (state.timer > 0) {
//         emit(
//           state.copyWith(
//             timer: state.timer - 1,
//             selectedIndex: state.selectedIndex,
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Times Up')));
//         Future.delayed(Duration(seconds: 2), () {
//           emit(
//             state.copyWith(
//               showAnswer: true,
//               isTimerEnded: true,
//               selectedIndex: state.currentQuestion.correctIndex,
//               // Why i got the correct Answer 0 i have set the value of 2 you can check on the above question model
//             ),
//           );
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
//     int timeBonus = isCorrect == true ? (state.timer >= 20 ? 1 : 0) : 0;
//
//     int pointsThisQuestion = 0;
//     int bonusPointsThisQuestion = 0;
//
//     if (isCorrect) {
//       pointsThisQuestion = 2;
//       if (state.timer > 20) {
//         bonusPointsThisQuestion = 1;
//       }
//     }
//
//     final timeSpentThisQuestion = 40 - state.timer;
//     final updatedResults = List<QuestionResult>.from(state.questionResults);
//
//     updatedResults[state.currentIndex] = QuestionResult(
//       userAnswerIndex: state.selectedIndex,
//       correctPoint: pointsThisQuestion,
//       bonusPoint: bonusPointsThisQuestion,
//       timeTakenSeconds: timeSpentThisQuestion,
//     );
//
//     // Update global accumulators if needed or keep as is
//     final newPointsEarned = state.pointsEarned + pointsThisQuestion;
//     final newBonusPoints = state.bonusPoints + bonusPointsThisQuestion;
//     final newScoreA = state.score + pointsThisQuestion + bonusPointsThisQuestion;
//     final newTimeTaken = state.timeTaken + timeSpentThisQuestion;
//
//     emit(
//       state.copyWith(
//         questionResults: updatedResults,
//         selectedIndex: state.selectedIndex,
//         showAnswer: true,
//         correctAnswers: isCorrect
//             ? state.correctAnswers + 1
//             : state.correctAnswers,
//         wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
//         score: newScoreA,
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
//     final isLast = state.currentIndex == state.questions.length - 1;
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
//     } else {
//       _timer?.cancel();
//
//       String formatTime(int seconds) {
//         if (seconds < 60) {
//           return "${seconds}s";
//         } else {
//           final minutes = seconds ~/ 60;
//           final remainingSeconds = seconds % 60;
//           if (remainingSeconds == 0) {
//             return "${minutes}m";
//           } else {
//             return "${minutes}m ${remainingSeconds}s";
//           }
//         }
//       }
//
//       String indexToLetter(int? index) {
//         if (index == null) return "";
//         return String.fromCharCode(65 + index); // 65 = 'A'
//       }
//
//       // Build detailed question results
//       final List<Map<String, dynamic>> categoryQuestions = [];
//       for (int i = 0; i < state.questions.length; i++) {
//         categoryQuestions.add({
//           "question": state.questions[i].question,
//           "options": List.generate(state.questions[i].options.length, (
//             optIndex,
//           ) {
//             return {
//               "label": String.fromCharCode(65 + optIndex), // A, B, C, D
//               "value": state.questions[i].options[optIndex],
//             };
//           }),
//           "answer": indexToLetter(state.questions[i].correctIndex),
//           "explanation": state.questions[i].hint,
//           "user_answered": indexToLetter(
//             state.questionResults[i].userAnswerIndex,
//           ),
//           "correct_point": state.questionResults[i].correctPoint,
//           "bonus_point": state.questionResults[i].bonusPoint,
//           "time_taken": state.questionResults[i].timeTakenSeconds,
//         });
//       }
//
//       // Final totals
//       final allCorrectBonus = (state.correctAnswers == state.questions.length)
//           ? 3
//           : 0;
//       final finalScore = state.score + allCorrectBonus;
//
//       // Build payload
//       final payload = {
//         "total_questions": state.questions.length,
//         "correct_answers": state.correctAnswers,
//         "correct_points": state.pointsEarned,
//         "earned_points": finalScore,
//         "additional_points": state.bonusPoints,
//         "total_time": formatTime(state.timeTaken),
//         "altitude_conversions_mixed_calculations": categoryQuestions,
//         "weight_balance_conversions": categoryQuestions,
//         "distance_range_conversions": categoryQuestions,
//         "fuel_volume_flow_conversions": categoryQuestions,
//         "pressure_weather_data_conversions": categoryQuestions,
//         "speed_time_calculations": categoryQuestions,
//         "temperature_conversions_impact": categoryQuestions,
//       };
//
//       void debugPrintFull(dynamic data) {
//         const int chunkSize = 800; // keep it under console limit
//         final jsonStr = jsonEncode(data);
//         for (var i = 0; i < jsonStr.length; i += chunkSize) {
//           debugPrint(jsonStr.substring(i, i + chunkSize > jsonStr.length ? jsonStr.length : i + chunkSize));
//         }
//       }
//       debugPrintFull(payload);
//       print("Final Payload: $payload");
//
//       // try {
//       //   await QuizQuestionRepository().submitCalculationResult(payload);
//       // } catch (e) {
//       //   print("Submit API failed: $e");
//       // }
//       final percent = (state.correctAnswers / state.questions.length) * 100;
//       final winAchieved = percent >= 80;
//
//       Future.delayed(const Duration(milliseconds: 100), () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CalculationResultScreen(
//               correctedAnswer: state.correctAnswers,
//               totalQuestion: state.questions.length,
//               score: finalScore,
//               winAchieved: winAchieved,
//               bonusPoints: 0,
//             ),
//           ),
//         );
//       });
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
import 'dart:convert';
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

  QuizQuestionCubit(int sectionId, BuildContext context)
      : super(QuizQuestionState.initial()) {
    loadQuestions(sectionId, context);
  }

  Future<void> loadQuestions(int sectionId, BuildContext context) async {
    try {
      emit(state.copyWith(isLoading: true));

      final calculationData = await QuizQuestionRepository().getCalculationData();

      if (calculationData == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'No internet or no data',
          ),
        );
        return;
      }

      final result = calculationData.result;

      // Map questions to their respective categories
      final altitudeQuestions = result.altitudeConversionsMixedCalculations
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final weightQuestions = result.weightBalanceConversions
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final distanceQuestions = result.distanceRangeConversions
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final fuelQuestions = result.fuelVolumeFlowConversions
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final pressureQuestions = result.pressureWeatherDataConversions
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final speedQuestions = result.speedTimeCalculations
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      final temperatureQuestions = result.temperatureConversionsImpact
          .map((q) => QuizQuestion(
        question: q.question,
        options: q.options.map((o) => o.value).toList(),
        correctIndex: answerToIndex(q.answer),
        hint: q.explanation,
      ))
          .toList();

      // Combine all questions for quiz progression
      final allQuestions = [
        ...altitudeQuestions,
        ...weightQuestions,
        ...distanceQuestions,
        ...fuelQuestions,
        ...pressureQuestions,
        ...speedQuestions,
        ...temperatureQuestions,
      ];

      final initialResults = List<QuestionResult>.generate(
        allQuestions.length,
            (_) => QuestionResult(
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
          altitudeQuestions: altitudeQuestions,
          weightQuestions: weightQuestions,
          distanceQuestions: distanceQuestions,
          fuelQuestions: fuelQuestions,
          pressureQuestions: pressureQuestions,
          speedQuestions: speedQuestions,
          temperatureQuestions: temperatureQuestions,
        ),
      );

      startTimer(context);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  int answerToIndex(Answer answer) {
    switch (answer) {
      case Answer.A:
        return 0;
      case Answer.B:
        return 1;
      case Answer.C:
        return 2;
      case Answer.D:
        return 3;
    }
  }

  DateTime? _startTime;
  final int _totalDuration = 40;

  void startTimer(BuildContext context) {
    _startTime = DateTime.now();
    emit(state.copyWith(timer: 40));
    _timer?.cancel();
    print("Timer Start");
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime!).inSeconds;
      final remaining = _totalDuration - elapsed;

      if (remaining > 0) {
        emit(
          state.copyWith(
            timer: remaining,
            selectedIndex: state.selectedIndex,
          ),
        );
        print("Pending time $remaining");
      } else {
        print("Time out");
        _timer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Times Up')),
        );

        Future.delayed(const Duration(seconds: 2), () {
          emit(state.copyWith(
            showAnswer: true,
            isTimerEnded: true,
            selectedIndex: state.currentQuestion.correctIndex,
          ));
        });
      }
    });
  }

  void selectOption(int index) {
    emit(state.copyWith(selectedIndex: index, showAnswer: false));
  }

  void submitQuestion(BuildContext context) {
    _timer?.cancel();

    final isCorrect = state.selectedIndex == state.currentQuestion.correctIndex;
    int timeBonus = isCorrect && state.timer >= 20 ? 1 : 0;

    int pointsThisQuestion = isCorrect ? 2 : 0;
    int bonusPointsThisQuestion = timeBonus;

    final timeSpentThisQuestion = 40 - state.timer;
    final updatedResults = List<QuestionResult>.from(state.questionResults);

    updatedResults[state.currentIndex] = QuestionResult(
      userAnswerIndex: state.selectedIndex,
      correctPoint: pointsThisQuestion,
      bonusPoint: bonusPointsThisQuestion,
      timeTakenSeconds: timeSpentThisQuestion,
    );

    final newPointsEarned = state.pointsEarned + pointsThisQuestion;
    final newBonusPoints = state.bonusPoints + bonusPointsThisQuestion;
    final newScore = state.score + pointsThisQuestion + bonusPointsThisQuestion;
    final newTimeTaken = state.timeTaken + timeSpentThisQuestion;

    emit(
      state.copyWith(
        questionResults: updatedResults,
        selectedIndex: state.selectedIndex,
        showAnswer: true,
        correctAnswers: isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
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
    final isLast = state.currentIndex == state.questions.length - 1;

    if (!isLast) {
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
    } else {
      _timer?.cancel();

      String formatTime(int seconds) {
        return "${seconds}s";
      }

      String indexToLetter(int? index) {
        if (index == null) return "";
        return String.fromCharCode(65 + index); // 65 = 'A'
      }

      // Build category-specific question results
      buildCategoryQuestions(List<QuizQuestion> questions, int startIndex) {
        return questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = entry.value;
          final resultIndex = startIndex + i;
          return {
            "question": q.question,
            "options": List.generate(q.options.length, (optIndex) {
              return {
                "label": String.fromCharCode(65 + optIndex),
                "value": q.options[optIndex],
              };
            }),
            "answer": indexToLetter(q.correctIndex),
            "explanation": q.hint,
            "user_answered": indexToLetter(state.questionResults[resultIndex].userAnswerIndex),
            "correct_point": state.questionResults[resultIndex].correctPoint,
            "bonus_point": state.questionResults[resultIndex].bonusPoint,
            "time_taken": formatTime(state.questionResults[resultIndex].timeTakenSeconds),
          };
        }).toList();
      }

      // Calculate starting indices for each category
      int currentIndex = 0;
      final altitudeQuestions = buildCategoryQuestions(state.altitudeQuestions, currentIndex);
      currentIndex += state.altitudeQuestions.length;
      final weightQuestions = buildCategoryQuestions(state.weightQuestions, currentIndex);
      currentIndex += state.weightQuestions.length;
      final distanceQuestions = buildCategoryQuestions(state.distanceQuestions, currentIndex);
      currentIndex += state.distanceQuestions.length;
      final fuelQuestions = buildCategoryQuestions(state.fuelQuestions, currentIndex);
      currentIndex += state.fuelQuestions.length;
      final pressureQuestions = buildCategoryQuestions(state.pressureQuestions, currentIndex);
      currentIndex += state.pressureQuestions.length;
      final speedQuestions = buildCategoryQuestions(state.speedQuestions, currentIndex);
      currentIndex += state.speedQuestions.length;
      final temperatureQuestions = buildCategoryQuestions(state.temperatureQuestions, currentIndex);

      // Final totals
      final allCorrectBonus = (state.correctAnswers == state.questions.length) ? 3 : 0;
      final finalScore = state.score + allCorrectBonus;

      // Build payload
      final payload = {
        "total_questions": state.questions.length,
        "correct_answers": state.correctAnswers,
        "correct_points": state.pointsEarned,
        "earned_points": finalScore,
        "additional_points": state.bonusPoints,
        "total_time": formatTime(state.timeTaken),
        "data": {
          "altitude_conversions_mixed_calculations": altitudeQuestions,
          "weight_balance_conversions": weightQuestions,
          "distance_range_conversions": distanceQuestions,
          "fuel_volume_flow_conversions": fuelQuestions,
          "pressure_weather_data_conversions": pressureQuestions,
          "speed_time_calculations": speedQuestions,
          "temperature_conversions_impact": temperatureQuestions,
        },
      };

      void debugPrintFull(dynamic data) {
        const int chunkSize = 800;
        final jsonStr = jsonEncode(data);
        for (var i = 0; i < jsonStr.length; i += chunkSize) {
          debugPrint(jsonStr.substring(i, i + chunkSize > jsonStr.length ? jsonStr.length : i + chunkSize));
        }
      }

      debugPrintFull(payload);
      print("Final Payload: $payload");

      try {
        await QuizQuestionRepository().submitCalculationResult(payload);
      } catch (e) {
        print("Submit API failed: $e");
      }

      final percent = (state.correctAnswers / state.questions.length) * 100;
      final winAchieved = percent >= 80;

      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CalculationResultScreen(
              correctedAnswer: state.correctAnswers,
              totalQuestion: state.questions.length,
              score: finalScore,
              winAchieved: winAchieved,
              bonusPoints: state.bonusPoints,
            ),
          ),
        );
      });
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}