import 'dart:async';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';

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
bool isNeedToShowFlagOptions = false;

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isNeedToShowOrNot = false;
    isNeedToShowFlagOptions = false;
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.quizMainQuestionScreen,
    );
  }

  void _showRadioPopup(BuildContext context) {
    final quizCubit = context.read<QuizQuestionCubit>();

    showDialog(
      context: context,
      builder: (_) => RadioPopup(
        onSelected: (selectedIndex) {
          quizCubit.reportQuestionPostMethod(
            selectedIndex,
            quizCubit,
            context,
            widget.gameId,
          );
          setState(() {
            isNeedToShowFlagOptions = false;
          });
        },
        title: 'Report',
        options: const [
          'Incorrect Answer / Wrong Information',
          'Question is Not Clear',
          'Offensive or Inappropriate Content',
          'Other Issue',
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          QuizQuestionCubit(widget.sectionId, context, gameId: widget.gameId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: widget.sectionTitle,
              rightButton: isNeedToShowFlagOptions == false
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.flag, color: Colors.black),
                      onPressed: () async {
                        _showRadioPopup(context);
                      },
                    ),
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
                              isNeedToShowFlagOptions = false;
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
                      isNeedToShowFlagOptions = true;
                      isNeedToShowOrNot = true;
                    });
                  });
                }

                if (state.selectedIndex == null &&
                    state.showAnswer == false &&
                    state.isTimerEnded == false) {
                  isNeedToShowOrNot = false;
                  isNeedToShowFlagOptions = false;
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
                                if (state.timer.toInt() != 0 &&
                                    !state.showAnswer) {
                                  quizCubit.selectOption(index);
                                }
                              },
                              onNext: () {
                                if (state.isTimerEnded) {
                                  setState(() {
                                    isNeedToShowFlagOptions = false;
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
          );
        },
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

                  Center(
                    child: SizedBox(
                      width: kIsWeb
                          ? MediaQuery.of(context).size.width * 0.5
                          : double.infinity,
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

class RadioPopup extends StatefulWidget {
  final String title;
  final List<String> options;
  final void Function(String selectedIndex) onSelected;

  const RadioPopup({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  State<RadioPopup> createState() => _RadioPopupState();
}

class _RadioPopupState extends State<RadioPopup> {
  String? _errorText;
  int? _selectedOption;
  final TextEditingController _otherIssueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.76;
    if (width > 400) width = 400;

    final bool isOtherSelected =
        _selectedOption == widget.options.indexOf('Other Issue');

    final bool canSubmit =
        _selectedOption != null &&
        (!isOtherSelected || _otherIssueController.text.trim().isNotEmpty) &&
        _errorText == null;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.customBottomEnabledColour,
                      ),
                    ),
                  ],
                ),
              ),

              // Divider below title
              const Divider(thickness: 1, height: 1),

              // Options with divider
              ...widget.options.asMap().entries.map((entry) {
                int idx = entry.key;
                String option = entry.value;
                return Column(
                  children: [
                    RadioListTile<int>(
                      value: idx,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;

                          // Clear text if user switches away from "Other Issue"
                          if (_selectedOption !=
                              widget.options.indexOf('Other Issue')) {
                            _otherIssueController.clear();
                            _errorText = null;
                          }
                        });
                      },

                      title: Text(option),
                    ),
                  ],
                );
              }).toList(),

              const Divider(thickness: 1, height: 1),

              if (isOtherSelected) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _otherIssueController,
                    maxLength: 20,
                    onChanged: (value) {
                      setState(() {
                        _errorText = value.length == 20
                            ? 'Maximum 20 characters allowed'
                            : null;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Describe issue',
                      errorText: _errorText,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.customBottomEnabledColour,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              if (!isOtherSelected) Divider(thickness: 1, height: 1),

              // Footer buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.customBottomEnabledColour,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Report Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canSubmit
                              ? AppColors.customBottomEnabledColour
                              : Colors.grey,
                        ),
                        onPressed: canSubmit
                            ? () {
                                widget.onSelected(
                                  _selectedOption ==
                                          widget.options.indexOf('Other Issue')
                                      ? _otherIssueController.text.trim()
                                      : widget.options[_selectedOption!],
                                );
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: const Text(
                          'Report',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
