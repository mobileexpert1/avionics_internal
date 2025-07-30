import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_state.dart';
import 'quiz_question_model.dart';

class QuizCubit extends Cubit<QuizState> {
  Timer? _timer;

  QuizCubit() : super(QuizState.initial()) {
    loadQuestions();
  }

  void loadQuestions() {
    final questions = [
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
        options: ['Stratosphere', 'Troposphere', 'Mesosphere', 'Thermosphere'],
        correctIndex: 1,
        hint: "Weather happens mostly in the troposphere.",
      ),
      QuizQuestion(
        question: "What is the coldest layer of the atmosphere?",
        options: ['Stratosphere', 'Mesosphere', 'Exosphere', 'Troposphere'],
        correctIndex: 1,
        hint: "Temperatures drop to the lowest in the mesosphere.",
      ),QuizQuestion(
        question:
        "The boundary that separates the troposphere from the stratosphere is called the __.",
        options: ['Mesopause', 'Stratopause', 'Tropopause', 'Thermopause'],
        correctIndex: 2,
        hint:
        "The transition boundary between the troposphere and the layer above is called the tropopause.",
      ),
      QuizQuestion(
        question: "Which layer contains most weather events?",
        options: ['Stratosphere', 'Troposphere', 'Mesosphere', 'Thermosphere'],
        correctIndex: 1,
        hint: "Weather happens mostly in the troposphere.",
      ),
      QuizQuestion(
        question: "What is the coldest layer of the atmosphere?",
        options: ['Stratosphere', 'Mesosphere', 'Exosphere', 'Troposphere'],
        correctIndex: 1,
        hint: "Temperatures drop to the lowest in the mesosphere.",
      ),
    ];

    emit(state.copyWith(questions: questions));
    startTimer(); // Start timer after loading
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
    _timer?.cancel();
    emit(state.copyWith(selectedIndex: index, showAnswer: true));
  }

  void nextQuestion() {
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
      // End of quiz logic here
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
