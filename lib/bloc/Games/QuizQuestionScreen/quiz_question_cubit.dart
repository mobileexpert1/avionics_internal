import 'dart:async';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_model.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';

class QuizQuestionCubit extends Cubit<QuizQuestionState> {
  Timer? _timer;

  QuizQuestionCubit(int sectionId) : super(QuizQuestionState.initial()) {
    loadQuestions(sectionId);
  }

  void loadQuestions(int sectionId) {
    List<QuizQuestion> questions;

    switch (sectionId) {
      case 1:
        questions = [
          QuizQuestion(
            question:
                "The boundary that separates the troposphere from the stratosphere is called the __.",
            options: ['Mesopause', 'Stratopause', 'Tropopause', 'Thermopause'],
            correctIndex: 2,
            hint:
                "The transition boundary between the troposphere and the layer above is called the tropopause.",
          ),
          QuizQuestion(
            question: "Which layer contains most weather events?",
            options: [
              'Stratosphere',
              'Troposphere',
              'Mesosphere',
              'Thermosphere',
            ],
            correctIndex: 1,
            hint: "Weather happens mostly in the troposphere.",
          ),
        ];
        break;

      case 2:
        questions = [
          QuizQuestion(
            question: "What is the coldest layer of the atmosphere?",
            options: ['Stratosphere', 'Mesosphere', 'Exosphere', 'Troposphere'],
            correctIndex: 1,
            hint: "Temperatures drop to the lowest in the mesosphere.",
          ),
          QuizQuestion(
            question: "Which gas is most abundant in the atmosphere?",
            options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Argon'],
            correctIndex: 1,
            hint: "Nitrogen makes up about 78% of Earth's atmosphere.",
          ),
        ];
        break;

      case 3:
        questions = [
          QuizQuestion(
            question: "Which layer contains the ozone layer?",
            options: ['Stratosphere', 'Troposphere', 'Mesosphere', 'Exosphere'],
            correctIndex: 0,
            hint: "The ozone layer lies within the stratosphere.",
          ),
          QuizQuestion(
            question: "Which layer is farthest from Earth?",
            options: ['Mesosphere', 'Troposphere', 'Stratosphere', 'Exosphere'],
            correctIndex: 3,
            hint: "The exosphere is the outermost layer of Earth's atmosphere.",
          ),
        ];
        break;

      case 4:
        questions = [
          QuizQuestion(
            question: "Which layer contains the auroras?",
            options: [
              'Troposphere',
              'Thermosphere',
              'Mesosphere',
              'Stratosphere',
            ],
            correctIndex: 1,
            hint: "Auroras occur in the thermosphere due to solar activity.",
          ),
          QuizQuestion(
            question: "At what layer do meteors usually burn up?",
            options: [
              'Troposphere',
              'Mesosphere',
              'Stratosphere',
              'Thermosphere',
            ],
            correctIndex: 1,
            hint: "Meteors usually burn up in the mesosphere.",
          ),
        ];
        break;

      default:
        questions = [];
    }

    emit(state.copyWith(questions: questions));
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    emit(state.copyWith(timer: 20, isTimerEnded: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer <= 1) {
        timer.cancel();
        emit(state.copyWith(timer: 0, isTimerEnded: true, showAnswer: true));
      } else {
        emit(state.copyWith(timer: state.timer - 1));
      }
    });
  }

  void selectOption(int index) {
    if (state.showAnswer) return;

    final isCorrect = index == state.currentQuestion.correctIndex;

    emit(
      state.copyWith(
        selectedIndex: index,
        showAnswer: true,
        correctAnswers: isCorrect
            ? state.correctAnswers + 1
            : state.correctAnswers,
        wrongAnswers: !isCorrect ? state.wrongAnswers + 1 : state.wrongAnswers,
      ),
    );

    _timer?.cancel();
  }

  void nextQuestion(BuildContext context) {
    if (state.currentIndex < state.questions.length - 1) {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          selectedIndex: null,
          showAnswer: false,
          timer: 20,
          isTimerEnded: false,
        ),
      );
      startTimer();
    } else {
      _timer?.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CalculationResultScreen(
            correctedAnswer: state.correctAnswers,
            totalQuestion: state.questions.length,
          ),
        ),
      );
      // End of quiz logic here
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
