import 'dart:async';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';

final GlobalKey _iconKey = GlobalKey();

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({
    super.key,
    required this.sectionId,
    required this.sectionTitle,
    required this.gameId,
  });

  final int sectionId;
  final String sectionTitle;
  final String gameId;

  @override
  _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
}

bool isNeedToShowOrNot = false;

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isNeedToShowOrNot = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          QuizQuestionCubit(widget.sectionId, context, gameId: widget.gameId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: widget.sectionTitle,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () async {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Exit Quiz?"),
                  backgroundColor: Colors.white,
                  content: const Text(
                    "Are you sure you want to exit? Your progress will be lost.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isNeedToShowOrNot = false;
                        });
                        Navigator.of(context).pop(true);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          AppColors.sepratorColourAppBar,
                        ),
                      ),
                      child: const Text("Yes, Exit"),
                    ),
                  ],
                ),
              );
              if (shouldExit ?? false) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: BlocBuilder<QuizQuestionCubit, QuizQuestionState>(
          builder: (context, state) {
            final quizCubit = context.read<QuizQuestionCubit>();

            if (state.questions.isEmpty && state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isTimerEnded && !isNeedToShowOrNot) {
              Future.delayed(const Duration(milliseconds: 50), () {
                setState(() {
                  isNeedToShowOrNot = true;
                });
              });
            }

            if (state.selectedIndex == null &&
                state.showAnswer == false &&
                state.isTimerEnded == false) {
              isNeedToShowOrNot = false;
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 200 : 10,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        QuizQuestionCard(
                          timeTaken: state.timeTaken,
                          hintText: state.currentQuestion.hint,
                          question: state.currentQuestion.question,
                          options: state.currentQuestion.options,
                          selectedOption: state.selectedIndex,
                          correctOption: state.currentQuestion.correctIndex,
                          isNeedToShowOrNot: isNeedToShowOrNot,
                          isShowAnswers: state.showAnswer,
                          currentQuestion: state.currentIndex + 1,
                          totalQuestions: 20,
                          secondsRemaining: state.timer,
                          onOptionSelected: (index) {
                            if (state.timer.toInt() != 0 && !state.showAnswer) {
                              quizCubit.selectOption(index);
                            }
                          },
                          onNext: () {
                            if (state.isTimerEnded) {
                              setState(() {
                                isNeedToShowOrNot = false;
                              });
                              quizCubit.nextQuestion(context);
                            } else if (state.selectedIndex != null ||
                                state.showAnswer) {
                              quizCubit.submitQuestion(context);

                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  if (_scrollController.hasClients) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position
                                          .maxScrollExtent,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                if (state.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class QuizQuestionCard extends StatelessWidget {
  final int timeTaken;
  final String hintText;
  final String question;
  final List<String> options;
  final int? selectedOption;
  final int correctOption;
  final bool isShowAnswers;
  final bool isNeedToShowOrNot;
  final int currentQuestion;
  final int totalQuestions;
  final int secondsRemaining;
  final Function(int) onOptionSelected;
  final VoidCallback? onNext;

  const QuizQuestionCard({
    required this.timeTaken,
    required this.hintText,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.isShowAnswers,
    required this.isNeedToShowOrNot,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    color: Color(0x14000000),
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
                      if (isCorrect && isShowAnswers) {
                        backgroundColor = timeTaken == 0
                            ? AppColors.customColourOfTimeExpired
                            : Colors.green.shade100;
                        borderColor = timeTaken == 0
                            ? Colors.blue
                            : Colors.green;
                        trailingIcon = const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        );
                      } else if (isSelected && !isCorrect && isShowAnswers) {
                        backgroundColor = Colors.red.shade100;
                        borderColor = Colors.red;
                        trailingIcon = const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        );
                      } else if (isSelected) {
                        backgroundColor = Colors.grey.shade300;
                        borderColor = Colors.white;
                      }
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

                  if (isNeedToShowOrNot)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 48,
                            width: 48,
                            child: GestureDetector(
                              key: _iconKey,
                              onTap: () {},
                              child: Image.asset(
                                CommonUi.setPngImage(AssetsPath.carFollowImage),
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              constraints: const BoxConstraints(maxWidth: 250),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                hintText,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomBottomButton(
                      title: isShowAnswers == false
                          ? ConstantStrings.submitTitle
                          : ConstantStrings.next,
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
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${secondsRemaining}s',
                      textAlign: TextAlign.left, // text alignment
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
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
