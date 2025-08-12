import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import '../../../Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';

class QuizQuestionCubit extends Cubit<QuizQuestionState> {
  Timer? _timer;

  QuizQuestionCubit(int sectionId, BuildContext context)
    : super(QuizQuestionState.initial()) {
    loadQuestions(sectionId, context);
  }

  void loadQuestions(int sectionId, BuildContext context) {
    List<QuizQuestion> questions;

    switch (sectionId) {
      case 1:
        questions = [
          QuizQuestion(
            question:
                "What is the primary layer of the atmosphere where commercial aircraft usually fly?",
            options: [
              'Stratosphere',
              'Troposphere',
              'Mesosphere',
              'Thermosphere',
            ],
            correctIndex: 0,
            hint: "The stratosphere is where most commercial jets cruise.",
          ),
          QuizQuestion(
            question:
                "What is the approximate altitude range of the troposphere?",
            options: [
              '0 to 12 km',
              '12 to 50 km',
              '50 to 80 km',
              'Above 80 km',
            ],
            correctIndex: 0,
            hint: "The troposphere extends from the surface up to about 12 km.",
          ),
          QuizQuestion(
            question:
                "Which weather phenomenon mostly occurs in the troposphere?",
            options: [
              'Aurora Borealis',
              'Solar flares',
              'Rain and thunderstorms',
              'Meteors',
            ],
            correctIndex: 2,
            hint: "Rain, storms, and clouds all occur in the troposphere.",
          ),
        ];
        break;

      case 2:
        questions = [
          QuizQuestion(
            question:
                "The boundary that separates the troposphere from the stratosphere is called the __",
            options: ['Mesopause', 'Stratopause', 'Tropopause', 'Thermopause'],
            correctIndex: 2,
            hint:
                "The tropopause separates the troposphere from the stratosphere.",
          ),
          QuizQuestion(
            question:
                "The increase in temperature in the stratosphere is primarily due to the absorption of _______ radiation by ozone.",
            options: ['Gamma', 'Infrared', 'Ultraviolet', 'Microwave'],
            correctIndex: 2,
            hint: "Ozone absorbs UV radiation, warming the stratosphere.",
          ),
          QuizQuestion(
            question:
                "Most meteorites burn up in the _______, leaving visible trails in the night sky.",
            options: [
              'Troposphere',
              'Mesosphere',
              'Stratosphere',
              'Thermosphere',
            ],
            correctIndex: 1,
            hint: "Meteors burn up in the mesosphere due to friction.",
          ),
        ];
        break;

      case 3:
        questions = [
          QuizQuestion(
            question: "What is 35,000 feet converted to kilometers (approx)?",
            options: ['12.2 km', '10.7 Km', '9.5 km', '8.2 km'],
            correctIndex: 1,
            hint: "35,000 ft ≈ 10.7 km",
          ),
          QuizQuestion(
            question:
                "If a jet is flying at 480 knots, what is its speed in Mach at sea level?",
            options: ['Mach 0.85', 'Mach 0.72', 'Mach 0.69', 'Mach 0.73'],
            correctIndex: 3,
            hint: "Approximation at sea level = Mach 0.73",
          ),
          QuizQuestion(
            question:
                "How many nautical miles are there in a 1,000 km flight path?",
            options: ['500 NM', '540 NM', '600 NM', '620 NM'],
            correctIndex: 1,
            hint: "1,000 km ≈ 540 NM (1 NM = 1.852 km)",
          ),
        ];
        break;

      default:
        questions = [];
    }

    emit(state.copyWith(questions: questions));
    startTimer(context);
  }

  void startTimer(BuildContext context) {
    _timer?.cancel();
    emit(state.copyWith(timer: 10));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer > 0) {
        emit(state.copyWith(timer: state.timer - 1,selectedIndex: state.selectedIndex));
      } else {
        _timer?.cancel();
        if (state.selectedIndex == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Times Up')));

          Future.delayed(Duration(seconds: 2), () {
            emit(
              state.copyWith(
                showAnswer: true,
                isTimerEnded: true,
                selectedIndex: state.correctAnswers,
              ),
            );
          });
        }
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
    int newScore = state.score;

    if (isCorrect) {
      newScore += 2 + timeBonus;
    }

    emit(
      state.copyWith(
        selectedIndex: state.selectedIndex,
        showAnswer: true,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
        score: newScore,
        isTimerEnded: true,
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

      final allCorrectBonus = (state.correctAnswers == state.questions.length)
          ? 3
          : 0;
      final finalScore = state.score + allCorrectBonus;

      final percent = (state.correctAnswers / state.questions.length) * 100;
      final winAchieved = percent >= 80;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CalculationResultScreen(
            correctedAnswer: state.correctAnswers,
            totalQuestion: state.questions.length,
            score: finalScore,
            winAchieved: winAchieved,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
