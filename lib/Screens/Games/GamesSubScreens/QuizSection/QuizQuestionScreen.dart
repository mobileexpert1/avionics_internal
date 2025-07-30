import 'dart:async';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_state.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizQuestionCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: ConstantStrings.aviationQuizTitle,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<QuizQuestionCubit, QuizQuestionState>(
          builder: (context, state) {
            if (state.questions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final quizCubit = context.read<QuizQuestionCubit>();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    QuizQuestionCard(
                      question: state.currentQuestion.question,
                      options: state.currentQuestion.options,
                      selectedOption: state.selectedIndex,
                      correctOption: state.currentQuestion.correctIndex,
                      currentQuestion: state.currentIndex + 1,
                      totalQuestions: state.questions.length,
                      secondsRemaining: state.timer,
                      onOptionSelected: (index) {
                        quizCubit.selectOption(index);
                      },
                      onNext: (state.selectedIndex != null || state.showAnswer)
                          ? () {
                              quizCubit.nextQuestion();
                            }
                          : null, // Only enable if answered or reveal is triggered
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuizQuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedOption; // <-- Make this nullable
  final int correctOption;

  final int currentQuestion;
  final int totalQuestions;
  final int secondsRemaining;
  final Function(int) onOptionSelected;
  final VoidCallback? onNext;

  const QuizQuestionCard({
    required this.question,
    required this.options,
    required this.correctOption,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.secondsRemaining,
    required this.onOptionSelected,
    this.selectedOption,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10), // margin 20
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuizProgressCard(
            currentQuestion: currentQuestion,
            totalQuestions: totalQuestions,
            secondsRemaining: secondsRemaining,
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000), // Light transparent black
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 13),
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(options.length, (index) {
                    final isSelected = index == selectedOption;
                    final isCorrect = index == correctOption;

                    Color backgroundColor = Colors.white;
                    Color borderColor = Colors.grey.shade300;
                    Icon? trailingIcon;

                    if (selectedOption != null) {
                      if (isCorrect) {
                        backgroundColor = Colors.green.shade100;
                        borderColor = Colors.green;
                        trailingIcon = const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        );
                      } else if (isSelected && !isCorrect) {
                        backgroundColor = Colors.red.shade100;
                        borderColor = Colors.red;
                        trailingIcon = const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        );
                      }
                    } else if (isSelected) {
                      backgroundColor = Colors.pink.shade100;
                      borderColor = Colors.pink;
                    }

                    String letter = String.fromCharCode(65 + index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => onOptionSelected(index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "$letter. ${options[index]}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null) trailingIcon,
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  if (selectedOption != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 48,
                          child: Image.asset(
                            CommonUi.setPngImage(AssetsPath.carFollowImage),
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomBottomButton(
                      title: ConstantStrings.next,
                      backgroundColor: AppColors.customBottomEnabledColour,
                      textColor: Colors.white,
                      icon: const SizedBox(width: 0),
                      isEnabled: selectedOption != null,
                      onPressed: onNext ?? () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizProgressCard extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int secondsRemaining;

  const QuizProgressCard({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.secondsRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = currentQuestion / totalQuestions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    '${secondsRemaining}s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          /// Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
