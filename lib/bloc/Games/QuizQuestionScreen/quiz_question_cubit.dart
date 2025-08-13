import 'dart:async';
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

      final calculationData = await QuizQuestionRepository()
          .getCalculationData();

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

      // Combine all categories into one big list
      final allCategoryQuestions = [
        ...result.altitudeConversionsMixedCalculations,
        ...result.weightBalanceConversions,
        ...result.distanceRangeConversions,
        ...result.fuelVolumeFlowConversions,
        ...result.pressureWeatherDataConversions,
        ...result.speedTimeCalculations,
        ...result.temperatureConversionsImpact,
      ];

      final questions = allCategoryQuestions
          .map(
            (q) => QuizQuestion(
              question: q.question,
              options: q.options.map((o) => o.value).toList(),
              correctIndex: answerToIndex(q.answer),
              hint: q.explanation,
            ),
          )
          .toList();

      final initialResults = List<QuestionResult>.generate(
        questions.length,
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
          questions: questions,
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
        ),
      );

      print('Emitted total questions count: ${questions.length}');
      startTimer(context);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  int answerToIndex(Answer answer) {
    // Map enum Answer {A, B, C, D} to index 0..3
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

  void startTimer(BuildContext context) {
    _timer?.cancel();
    emit(state.copyWith(timer: 40));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer > 0) {
        emit(
          state.copyWith(
            timer: state.timer - 1,
            selectedIndex: state.selectedIndex,
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Times Up')));
        Future.delayed(Duration(seconds: 2), () {
          emit(
            state.copyWith(
              showAnswer: true,
              isTimerEnded: true,
              selectedIndex: state.currentQuestion.correctIndex,
              // Why i got the correct Answer 0 i have set the value of 2 you can check on the above question model
            ),
          );
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
    int timeBonus = isCorrect == true ? (state.timer >= 20 ? 1 : 0) : 0;

    int pointsThisQuestion = 0;
    int bonusPointsThisQuestion = 0;

    if (isCorrect) {
      pointsThisQuestion = 2;
      if (state.timer > 20) {
        bonusPointsThisQuestion = 1;
      }
    }

    final timeSpentThisQuestion = 40 - state.timer;
    final updatedResults = List<QuestionResult>.from(state.questionResults);

    updatedResults[state.currentIndex] = QuestionResult(
      userAnswerIndex: state.selectedIndex,
      correctPoint: pointsThisQuestion,
      bonusPoint: bonusPointsThisQuestion,
      timeTakenSeconds: timeSpentThisQuestion,
    );

    // Update global accumulators if needed or keep as is
    final newPointsEarned = state.pointsEarned + pointsThisQuestion;
    final newBonusPoints = state.bonusPoints + bonusPointsThisQuestion;
    final newScoreA = state.score + pointsThisQuestion + bonusPointsThisQuestion;
    final newTimeTaken = state.timeTaken + timeSpentThisQuestion;

    emit(
      state.copyWith(
        questionResults: updatedResults,
        selectedIndex: state.selectedIndex,
        showAnswer: true,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
        score: newScoreA,
        pointsEarned: newPointsEarned,
        bonusPoints: newBonusPoints,
        timeTaken: newTimeTaken,
        isTimerEnded: true,
        totalBonusPoints: state.totalBonusPoints + timeBonus,
      ),
    );
  }

  void nextQuestion(BuildContext context) {
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
        if (seconds < 60) {
          return "${seconds}s";
        } else {
          final minutes = seconds ~/ 60;
          final remainingSeconds = seconds % 60;
          if (remainingSeconds == 0) {
            return "${minutes}m";
          } else {
            return "${minutes}m ${remainingSeconds}s";
          }
        }
      }

      String indexToLetter(int? index) {
        if (index == null) return "";
        return String.fromCharCode(65 + index); // 65 = 'A'
      }

      // Build detailed question results
      final List<Map<String, dynamic>> categoryQuestions = [];
      for (int i = 0; i < state.questions.length; i++) {
        categoryQuestions.add({
          "question": state.questions[i].question,
          "options": List.generate(state.questions[i].options.length, (
            optIndex,
          ) {
            return {
              "label": String.fromCharCode(65 + optIndex), // A, B, C, D
              "value": state.questions[i].options[optIndex],
            };
          }),
          "answer": indexToLetter(state.questions[i].correctIndex),
          "explanation": state.questions[i].hint,
          "user_answered": indexToLetter(
            state.questionResults[i].userAnswerIndex,
          ),
          "correct_point": state.questionResults[i].correctPoint,
          "bonus_point": state.questionResults[i].bonusPoint,
          "time_taken": state.questionResults[i].timeTakenSeconds,
        });
      }

      // Final totals
      final allCorrectBonus = (state.correctAnswers == state.questions.length)
          ? 3
          : 0;
      final finalScore = state.score + allCorrectBonus;

      // Build payload
      final payload = {
        "total_questions": state.questions.length,
        "correct_answers": state.correctAnswers,
        "total_correct_points": state.pointsEarned,
        "total_earned_points": finalScore,
        "additional_points": state.bonusPoints,
        "total_time": formatTime(state.timeTaken),
        "Altitude Conversions & Mixed Calculations": categoryQuestions,
        "Weight & Balance Conversions": categoryQuestions,
        "Distance/Range Conversions": categoryQuestions,
        "Fuel Volume/Flow Conversions": categoryQuestions,
        "Pressure & Weather Data Conversions": categoryQuestions,
        "Speed/Time Calculations": categoryQuestions,
        "Temperature Conversions & Impact": categoryQuestions,
      };

      print("Final Payload: $payload");

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
              bonusPoints: 0,
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
