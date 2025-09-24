import 'dart:async';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackBox_questioncubit.dart';
import '../../../../bloc/Games/SubGameSection/BlackBox_Section/blackBox_state.dart';
import 'BlackboxScreen.dart';

final GlobalKey _iconKey = GlobalKey();

class BlackBoxScreen extends StatefulWidget {
  const BlackBoxScreen({
    super.key,
    required this.sectionId,
    required this.gameId,
  });

  final int sectionId;
  final String gameId;

  @override
  _BlackBoxScreenState createState() => _BlackBoxScreenState();
}

bool isNeedToShowOrNot = false;

class _BlackBoxScreenState extends State<BlackBoxScreen> {
  bool isNeedToShowOrNot = false;

  @override
  void initState() {
    super.initState();
    isNeedToShowOrNot = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlackBoxQuestionCubit(
        widget.sectionId,
        context,
        gameId: widget.gameId,
      ),
      child: BlocBuilder<BlackBoxQuestionCubit, BlackBoxState>(
        builder: (context, state) {
          final blackBoxCubit = context.read<BlackBoxQuestionCubit>();

          if (state.questions.isEmpty && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.isTimerEnded && !isNeedToShowOrNot) {
            Future.delayed(const Duration(milliseconds: 50), () {
              if (mounted) {
                setState(() {
                  isNeedToShowOrNot = true;
                });
              }
            });
          }

          if (state.selectedIndex == null &&
              state.selectedSequence == null &&
              state.selectedAnswer == null &&
              state.showAnswer == false &&
              state.isTimerEnded == false) {
            if (isNeedToShowOrNot) {
              setState(() {
                isNeedToShowOrNot = false;
              });
            }
          }
          final currentQuestionTitle =
              state.currentQuestion.title?.isNotEmpty == true
              ? state.currentQuestion.title!
              : 'Question';

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: currentQuestionTitle,
              leftButton: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () async {
                  final shouldExit = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Exit BlackBox?"),
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
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const BlackBoxStartScreen(
                                  gameId: 'black_box',
                                ),
                              ),
                              (route) => false,
                            );
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

            //Animation App bar
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   automaticallyImplyLeading: false,
            //   surfaceTintColor: Colors.white,
            //   elevation: 0,
            //   leading: IconButton(
            //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            //     onPressed: () async {
            //       final shouldExit = await showDialog<bool>(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: const Text("Exit BlackBox?"),
            //           backgroundColor: Colors.white,
            //           content: const Text(
            //             "Are you sure you want to exit? Your progress will be lost.",
            //           ),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.of(context).pop(false),
            //               child: const Text(
            //                 "Cancel",
            //                 style: TextStyle(color: Colors.black),
            //               ),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pushAndRemoveUntil(
            //                   MaterialPageRoute(
            //                     builder: (context) => const BlackBoxStartScreen(
            //                       gameId: 'black_box',
            //                     ),
            //                   ),
            //                   (route) => false,
            //                 );
            //               },
            //               style: TextButton.styleFrom(
            //                 backgroundColor: Colors.blue,
            //                 foregroundColor: Colors.white,
            //               ),
            //               child: const Text("Yes, Exit"),
            //             ),
            //           ],
            //         ),
            //       );
            //       if (shouldExit ?? false) {
            //         Navigator.pop(context);
            //       }
            //     },
            //   ),
            //   centerTitle: true,
            //   title: AnimatedTitle(
            //     text: currentQuestionTitle,
            //   ),
            // ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        BlackBoxCard(
                          key: ValueKey(state.currentIndex),
                          timeTaken: state.timeTaken,
                          hintText: state.currentQuestion.hint,
                          questionType: state.currentQuestion.type,
                          question: state.currentQuestion.question,
                          options: state.currentQuestion.options,
                          correctOption: state.currentQuestion.correctIndex,
                          userAnswer: state.selectedIndex == null
                              ? null
                              : state.selectedIndex == 0,
                          selectedIndex: state.selectedIndex,
                          selectedSequence: state.selectedSequence,
                          sequenceItems:
                              state.selectedSequenceItems ??
                              state.currentQuestion.sequenceItems ??
                              [],
                          correctSequence:
                              state.currentQuestion.sequenceItems ?? [],
                          isNeedToShowOrNot: isNeedToShowOrNot,
                          isShowAnswers: state.showAnswer,
                          currentQuestion: state.currentIndex + 1,
                          totalQuestions: state.questions.length,
                          secondsRemaining: state.timer,
                          onTrueFalseSelected: (isTrue) {
                            if (state.timer.toInt() != 0 && !state.showAnswer) {
                              blackBoxCubit.selectTrueFalse(isTrue ? 0 : 1);
                            }
                          },
                          onOptionSelected: (index) {
                            if (state.timer.toInt() != 0 && !state.showAnswer) {
                              blackBoxCubit.selectOption(index);
                            }
                          },
                          onSequenceReordered: (newSequence) {
                            if (state.timer.toInt() != 0 && !state.showAnswer) {
                              blackBoxCubit.updateSequence(newSequence);
                            }
                          },
                          onShortAnswerChanged: (answer) {
                            if (state.timer.toInt() != 0 && !state.showAnswer) {
                              blackBoxCubit.updateShortAnswer(answer);
                            }
                          },
                          onNext: () {
                            if (state.isTimerEnded || state.showAnswer) {
                              setState(() {
                                isNeedToShowOrNot = false;
                              });
                              blackBoxCubit.nextQuestion(context);
                            } else if (state.selectedIndex != null ||
                                state.selectedSequence != null ||
                                state.selectedAnswer != null) {
                              blackBoxCubit.submitQuestion(context);
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
            ),
          );
        },
      ),
    );
  }
}

class BlackBoxCard extends StatelessWidget {
  final int timeTaken;
  final String hintText;
  final String questionType;
  final String question;
  final List<String> options;
  final int correctOption;
  final bool? userAnswer;
  final List<String> sequenceItems;
  final List<String> correctSequence;
  final bool isShowAnswers;
  final bool isNeedToShowOrNot;
  final int currentQuestion;
  final int totalQuestions;
  final int secondsRemaining;
  final Function(bool) onTrueFalseSelected;
  final Function(int) onOptionSelected;
  final Function(List<String>) onSequenceReordered;
  final Function(String) onShortAnswerChanged;
  final VoidCallback? onNext;
  final int? selectedIndex;
  final List<int>? selectedSequence;

  const BlackBoxCard({
    super.key,
    required this.timeTaken,
    required this.hintText,
    required this.questionType,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.isShowAnswers,
    required this.isNeedToShowOrNot,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.secondsRemaining,
    required this.onTrueFalseSelected,
    required this.onOptionSelected,
    required this.onSequenceReordered,
    required this.onShortAnswerChanged,
    this.userAnswer,
    this.sequenceItems = const [],
    this.correctSequence = const [],
    this.onNext,
    this.selectedIndex,
    this.selectedSequence,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlackBoxProgressCard(
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
                  if (questionType == '2')
                    _buildTrueFalseOptions(context)
                  else if (questionType == '3')
                    _buildMultipleChoiceOptions()
                  else if (questionType == '1')
                    _buildEventSequence(context)
                  else
                    const Text('Unsupported question type'),
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
                      isEnabled: _isSubmitEnabled(),
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

  Widget _buildTrueFalseOptions(BuildContext context) {
    return Column(
      children: [
        _buildTrueFalseButton(context, true, 'A. True'),
        const SizedBox(height: 12),
        _buildTrueFalseButton(context, false, 'B. False'),
      ],
    );
  }

  Widget _buildTrueFalseButton(
    BuildContext context,
    bool isTrue,
    String label,
  ) {
    final isSelected = userAnswer != null && userAnswer == isTrue;
    final isCorrect = isTrue == (correctOption == 0);
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    Icon? trailingIcon;

    if (isShowAnswers) {
      if (isCorrect) {
        backgroundColor = timeTaken == 0
            ? AppColors.customColourOfTimeExpired
            : Colors.green.shade100;
        borderColor = timeTaken == 0 ? Colors.blue : Colors.green;
        trailingIcon = const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        );
      } else if (isSelected! && !isCorrect) {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
        trailingIcon = const Icon(Icons.cancel, color: Colors.red, size: 20);
      }
    } else if (isSelected!) {
      backgroundColor = Colors.grey.shade300;
      borderColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: secondsRemaining > 0 && !isShowAnswers
            ? () => onTrueFalseSelected(isTrue)
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
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
  }

  Widget _buildMultipleChoiceOptions() {
    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = selectedIndex == index;
        final isCorrect = index == correctOption;

        Color backgroundColor = Colors.white;
        Color borderColor = Colors.grey.shade300;
        Icon? trailingIcon;

        if (isShowAnswers) {
          if (isCorrect) {
            backgroundColor = timeTaken == 0
                ? AppColors.customColourOfTimeExpired
                : Colors.green.shade100;
            borderColor = timeTaken == 0 ? Colors.blue : Colors.green;
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
          backgroundColor = Colors.grey.shade300;
          borderColor = Colors.white;
        }

        String letter = String.fromCharCode(65 + index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: secondsRemaining > 0 && !isShowAnswers
                ? () => onOptionSelected(index)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
    );
  }

  // Widget _buildEventSequence(BuildContext context) {
  //   final state = context.watch<BlackBoxQuestionCubit>().state;
  //   final options = state.currentQuestion.options ?? [];
  //
  //   final sequenceItems =
  //       state.selectedSequenceItems ?? List<String>.from(options);
  //   final correctSequence = state.currentQuestion.correctSequence ?? [];
  //
  //   final isCorrectSequence =
  //       state.showAnswer &&
  //       sequenceItems.length == correctSequence.length &&
  //       List.generate(
  //         sequenceItems.length,
  //         (index) => sequenceItems[index] == options[correctSequence[index]],
  //       ).every((isMatch) => isMatch);
  //
  //   final displaySequence = sequenceItems;
  //   final originalLabels = Map<String, String>.fromIterables(
  //     options,
  //     List.generate(options.length, (i) => String.fromCharCode(65 + i)),
  //   );
  //
  //   return ReorderableListView(
  //     buildDefaultDragHandles: false,
  //     onReorder: (oldIndex, newIndex) {
  //       if (state.timer > 0 && !state.showAnswer) {
  //         final newList = List<String>.from(sequenceItems);
  //         if (newIndex > oldIndex) newIndex -= 1;
  //         final item = newList.removeAt(oldIndex);
  //         newList.insert(newIndex, item);
  //         context.read<BlackBoxQuestionCubit>().updateSequence(newList);
  //       }
  //     },
  //     children: displaySequence.map((item) {
  //       final optionIndex = options.indexOf(item);
  //
  //       Color backgroundColor = state.showAnswer
  //           ? (isCorrectSequence ? Colors.green.shade100 : Colors.red.shade100)
  //           : Colors.grey.shade100;
  //
  //       Color borderColor = state.showAnswer
  //           ? (isCorrectSequence ? Colors.green : Colors.red)
  //           : Colors.grey.shade300;
  //
  //       Icon? trailingIcon = state.showAnswer
  //           ? Icon(
  //               isCorrectSequence ? Icons.check_circle : Icons.cancel,
  //               color: isCorrectSequence ? Colors.green : Colors.red,
  //               size: 20,
  //             )
  //           : null;
  //
  //       final label =
  //           originalLabels[item] ?? String.fromCharCode(65 + optionIndex);
  //
  //       return ReorderableDragStartListener(
  //         key: ValueKey(item), // stable key based on option text
  //         index: displaySequence.indexOf(item),
  //         enabled: state.timer > 0 && !state.showAnswer,
  //         child: Container(
  //           margin: const EdgeInsets.only(bottom: 12),
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  //           decoration: BoxDecoration(
  //             color: backgroundColor,
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(color: borderColor),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 width: 30,
  //                 height: 30,
  //                 decoration: const BoxDecoration(
  //                   color: Colors.blue,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   label,
  //                   style: const TextStyle(color: Colors.white, fontSize: 14),
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(child: Text(item)),
  //               ReorderableDragStartListener(
  //                 index: displaySequence.indexOf(item),
  //                 enabled: state.timer > 0 && !state.showAnswer,
  //                 child: const Icon(Icons.drag_handle, color: Colors.grey),
  //               ),
  //               if (trailingIcon != null) trailingIcon,
  //             ],
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //   );
  // }

  Widget _buildEventSequence(BuildContext context) {
    final state = context.watch<BlackBoxQuestionCubit>().state;
    final options = state.currentQuestion.options ?? [];

    final sequenceItems =
        state.selectedSequenceItems ?? List<String>.from(options);
    final correctSequence = state.currentQuestion.correctSequence ?? [];

    final isCorrectSequence =
        state.showAnswer &&
        sequenceItems.length == correctSequence.length &&
        List.generate(
          sequenceItems.length,
          (index) => sequenceItems[index] == options[correctSequence[index]],
        ).every((isMatch) => isMatch);

    final displaySequence = sequenceItems;
    final originalLabels = Map<String, String>.fromIterables(
      options,
      List.generate(options.length, (i) => String.fromCharCode(65 + i)),
    );

    return ReorderableListView(
      buildDefaultDragHandles: false,
      onReorder: (oldIndex, newIndex) {
        if (state.timer > 0 && !state.showAnswer) {
          final newList = List<String>.from(sequenceItems);
          if (newIndex > oldIndex) newIndex -= 1;
          final item = newList.removeAt(oldIndex);
          newList.insert(newIndex, item);
          context.read<BlackBoxQuestionCubit>().updateSequence(newList);
        }
      },
      children: displaySequence.map((item) {
        final optionIndex = options.indexOf(item);

        Color backgroundColor = state.showAnswer
            ? (isCorrectSequence ? Colors.green.shade100 : Colors.red.shade100)
            : Colors.grey.shade100;

        Color borderColor = state.showAnswer
            ? (isCorrectSequence ? Colors.green : Colors.red)
            : Colors.grey.shade300;

        Icon? trailingIcon = state.showAnswer
            ? Icon(
                isCorrectSequence ? Icons.check_circle : Icons.cancel,
                color: isCorrectSequence ? Colors.green : Colors.red,
                size: 20,
              )
            : null;

        final label =
            originalLabels[item] ?? String.fromCharCode(65 + optionIndex);
        return Container(
          key: ValueKey(item),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(item)),
              ReorderableDragStartListener(
                index: displaySequence.indexOf(item),
                enabled: state.timer > 0 && !state.showAnswer,
                child: Container(
                  padding: const EdgeInsets.all(12), // increase touch area
                  child: const Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),

              if (trailingIcon != null) trailingIcon,
            ],
          ),
        );
      }).toList(),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  bool _isSubmitEnabled() {
    switch (questionType) {
      case '1':
        return selectedSequence != null;
      case '2':
        return selectedIndex != null;
      case '3':
        return selectedIndex != null;
      default:
        return false;
    }
  }
}

class BlackBoxProgressCard extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int secondsRemaining;

  const BlackBoxProgressCard({
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
                      textAlign: TextAlign.left,
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

class AnimatedTitle extends StatefulWidget {
  final String text;
  const AnimatedTitle({super.key, required this.text});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(-1.5, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF151A6A),
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
