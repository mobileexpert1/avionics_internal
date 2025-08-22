// import 'dart:async';
// import 'dart:ffi';
// import 'package:avionics_internal/Constants/AppColors.dart';
// import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
// import 'package:avionics_internal/Screens/Games/GamesSubScreens/CalculationSection/CalculationResultScreen.dart';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
// import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../../Constants/constantImages.dart';
// import '../../../../Helpers/CustomToast/CustomToast.dart';
// import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_cubit.dart';
// import '../../../../bloc/Games/SubGameSection/Quiz_Section/quiz_state.dart';
// import 'package:avionics_internal/Constants/ConstantStrings.dart';
// import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
// import 'dart:ui' as dart_ui;
//
// OverlayEntry? _popupOverlayEntry;
//
// class QuizQuestionScreen extends StatefulWidget {
//   const QuizQuestionScreen({
//     super.key,
//     required this.sectionId,
//     required this.sectionTitle,
//   });
//
//   final int sectionId;
//   final String sectionTitle;
//
//   @override
//   void initState() {
//     _popupShown = false;
//     isNeedToShowOrNot = false;
//   }
//
//   @override
//   _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
// }
//
// final GlobalKey _iconKey = GlobalKey();
//
// bool isNeedToShowOrNot = false;
// bool _popupShown = false;
//
// class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _popupShown = false;
//     isNeedToShowOrNot = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => QuizQuestionCubit(widget.sectionId, context),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           title: widget.sectionTitle,
//           leftButton: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () async {
//               final shouldExit = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text("Exit Quiz?"),
//                   backgroundColor: Colors.white,
//                   // Set your desired background color here
//                   content: Text(
//                     "Are you sure you want to exit? Your progress will be lost.",
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       style: ButtonStyle(
//                         foregroundColor: MaterialStateProperty.all<Color>(
//                           Colors.black,
//                         ), // Text color
//                       ),
//                       child: Text("Cancel"),
//                     ),
//
//                     TextButton(
//                       onPressed: () => {
//                         _popupOverlayEntry?.remove(),
//                         _popupOverlayEntry = null,
//                         setState(() {
//                           isNeedToShowOrNot = false;
//                         }),
//                         Navigator.of(context).pop(true),
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                           Colors.blue,
//                         ), // Background color
//                         foregroundColor: MaterialStateProperty.all<Color>(
//                           AppColors.sepratorColourAppBar,
//                         ), // Text color
//                       ),
//                       child: Text("Yes, Exit"),
//                     ),
//                   ],
//                 ),
//               );
//               if (shouldExit ?? false) {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ),
//         body: BlocBuilder<QuizQuestionCubit, QuizQuestionState>(
//           builder: (context, state) {
//             final quizCubit = context.read<QuizQuestionCubit>();
//             if (state.questions.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state.isTimerEnded && !_popupShown) {
//               final isLast = state.currentIndex == state.questions.length - 1;
//               _popupShown = true; // prevent multiple triggers
//               Future.delayed(const Duration(milliseconds: 10), () {
//                 setState(() {
//                   isNeedToShowOrNot = true;
//                 });
//
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   Future.delayed(const Duration(milliseconds: 30), () {
//                     showPopupBelowIcon(
//                       context,
//                       _iconKey,
//                       ArrowDirection.right,
//                       isNeedToShowOrNot,
//                       state.currentQuestion.hint,
//                       onDismissed: () {
//                         _popupShown = false; // reset for next question
//                         quizCubit.nextQuestion(context);
//                       },
//                     );
//                   });
//                 });
//               });
//             }
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 24),
//                     QuizQuestionCard(
//                       hintText: state.currentQuestion.hint,
//                       question: state.currentQuestion.question,
//                       options: state.currentQuestion.options,
//                       selectedOption: state.selectedIndex,
//                       correctOption: state.currentQuestion.correctIndex,
//                       isNeedToShowOrNot: isNeedToShowOrNot,
//                       isShowAnswers: state.showAnswer,
//                       currentQuestion: state.currentIndex + 1,
//                       totalQuestions: state.questions.length,
//                       secondsRemaining: state.timer,
//                       onOptionSelected: (index) {
//                         if (state.timer.toInt() != 0) {
//                           if (state.showAnswer == false) {
//                             quizCubit.selectOption(index);
//                           }
//                         }
//                       },
//                       onNext: () {
//                         if (state.isTimerEnded == true) {
//                           _popupOverlayEntry?.remove();
//                           _popupOverlayEntry = null;
//                           if (state.currentIndex ==
//                               state.questions.length - 1) {
//                             _popupShown = false;
//                             isNeedToShowOrNot = false;
//                           } else {
//                             setState(() {
//                               _popupShown = false;
//                               isNeedToShowOrNot = false;
//                             });
//                           }
//                           quizCubit.nextQuestion(context);
//                         } else if (state.selectedIndex != null ||
//                             state.showAnswer) {
//                           quizCubit.submitQuestion(context);
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class QuizQuestionCard extends StatelessWidget {
//   final String hintText;
//   final String question;
//   final List<String> options;
//   final int? selectedOption;
//   final int correctOption;
//   final bool isShowAnswers;
//   final bool isNeedToShowOrNot;
//
//   final int currentQuestion;
//   final int totalQuestions;
//   final int secondsRemaining;
//   final Function(int) onOptionSelected;
//   final VoidCallback? onNext;
//
//   const QuizQuestionCard({
//     required this.hintText,
//     required this.question,
//     required this.options,
//     required this.correctOption,
//     required this.isShowAnswers,
//     required this.isNeedToShowOrNot,
//
//     required this.currentQuestion,
//     required this.totalQuestions,
//     required this.secondsRemaining,
//     required this.onOptionSelected,
//     this.selectedOption,
//     this.onNext,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           QuizProgressCard(
//             currentQuestion: currentQuestion,
//             totalQuestions: totalQuestions,
//             secondsRemaining: secondsRemaining,
//           ),
//
//           const SizedBox(height: 20),
//
//           SingleChildScrollView(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0x14000000),
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 13),
//                   Text(
//                     question,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//                   ...List.generate(options.length, (index) {
//                     final isSelected = index == selectedOption;
//                     final isCorrect = index == correctOption;
//
//                     Color backgroundColor = Colors.white;
//                     Color borderColor = Colors.grey.shade300;
//                     Icon? trailingIcon;
//
//                     if (selectedOption != null) {
//                       if (isCorrect && isShowAnswers) {
//                         backgroundColor = Colors.green.shade100;
//                         borderColor = Colors.green;
//                         trailingIcon = const Icon(
//                           Icons.check_circle,
//                           color: Colors.green,
//                           size: 20,
//                         );
//                       } else if (isSelected && !isCorrect && isShowAnswers) {
//                         backgroundColor = Colors.red.shade100;
//                         borderColor = Colors.red;
//                         trailingIcon = const Icon(
//                           Icons.cancel,
//                           color: Colors.red,
//                           size: 20,
//                         );
//                       } else if (isSelected) {
//                         backgroundColor = Colors.grey.shade300;
//                         borderColor = Colors.white;
//                       }
//                     }
//
//                     String letter = String.fromCharCode(65 + index);
//
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: InkWell(
//                         onTap: () => onOptionSelected(index),
//                         borderRadius: BorderRadius.circular(8),
//                         child: Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 16,
//                           ),
//                           decoration: BoxDecoration(
//                             color: backgroundColor,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: borderColor),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "$letter. ${options[index]}",
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               if (trailingIcon != null) trailingIcon,
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//
//                   const SizedBox(height: 10),
//
//                   if (isNeedToShowOrNot == true)
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: SizedBox(
//                           height: 48,
//                           child: GestureDetector(
//                             key: _iconKey,
//                             onTap: () {},
//                             child: Image.asset(
//                               CommonUi.setPngImage(AssetsPath.carFollowImage),
//                               width: 46,
//                               height: 46,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   const SizedBox(height: 16),
//
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: CustomBottomButton(
//                       title: isShowAnswers == false
//                           ? ConstantStrings.submitTitle
//                           : ConstantStrings.next,
//                       backgroundColor: AppColors.customBottomEnabledColour,
//                       textColor: Colors.white,
//                       icon: const SizedBox(width: 0),
//                       isEnabled: selectedOption != null,
//                       onPressed: onNext ?? () {},
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class QuizProgressCard extends StatelessWidget {
//   final int currentQuestion;
//   final int totalQuestions;
//   final int secondsRemaining;
//
//   const QuizProgressCard({
//     Key? key,
//     required this.currentQuestion,
//     required this.totalQuestions,
//     required this.secondsRemaining,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double progress = currentQuestion / totalQuestions;
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300, width: 1),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x14000000),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Question $currentQuestion of $totalQuestions',
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, color: Colors.blue),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${secondsRemaining}s',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//
//           /// Progress bar
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: LinearProgressIndicator(
//               value: progress,
//               minHeight: 10,
//               backgroundColor: Colors.grey.shade200,
//               valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
//
// void showPopupBelowIcon(
//   BuildContext context,
//   GlobalKey key,
//   ArrowDirection direction,
//   bool isNeedToShowOrNot,
//   String hintText, {
//   VoidCallback? onDismissed,
// }) {
//   if (!isNeedToShowOrNot) return;
//   if (key.currentContext == null) return;
//
//   final render = key.currentContext!.findRenderObject();
//   if (render == null || render is! RenderBox) return;
//   final renderBox = render as RenderBox;
//
//   final dart_ui.Size size = renderBox.size;
//   final Offset offset = renderBox.localToGlobal(Offset.zero);
//
//   final double screenWidth = MediaQuery.of(context).size.width;
//   final double popupWidth = 250;
//   final double horizontalPadding = 20;
//
//   double leftPosition;
//   if (direction == ArrowDirection.right) {
//     leftPosition =
//         offset.dx +
//         size.width +
//         MediaQuery.of(context).padding.right +
//         (defaultTargetPlatform == TargetPlatform.iOS ? 30 : 20);
//     if (leftPosition + popupWidth > screenWidth) {
//       leftPosition = screenWidth - popupWidth - horizontalPadding;
//     }
//   } else {
//     leftPosition = offset.dx - popupWidth - 8;
//     if (leftPosition < horizontalPadding) {
//       leftPosition = horizontalPadding;
//     }
//   }
//
//   // Remove existing popup if any
//   _popupOverlayEntry?.remove();
//
//   _popupOverlayEntry = OverlayEntry(
//     builder: (context) {
//       return Positioned(
//         left: leftPosition,
//         top:
//             offset.dy +
//             size.height / 2 -
//             (MediaQuery.of(context).viewInsets.bottom + 50),
//         child: Material(
//           color: Colors.transparent,
//           child: Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.center,
//             children: [
//               // Tooltip Container
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 constraints: const BoxConstraints(maxWidth: 250),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 8,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   hintText,
//                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                 ),
//               ),
//
//               // Arrow
//
//               Positioned(
//                 left:
//                 direction ==
//                     ArrowDirection.right ? -10 : null,
//
//                 right:
//                 direction ==
//                     ArrowDirection.left ? -10 : null,
//                 child: CustomPaint(
//                   size: const dart_ui.Size(20, 20),
//                   painter: TrianglePainter(
//                     color: Colors.white,
//                     direction: direction == ArrowDirection.right
//                         ? ArrowDirection.left
//                         : ArrowDirection.right,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
//
//   Overlay.of(context).insert(_popupOverlayEntry!);
// }
//
//
//
//
//
//
//
//
//
//

import 'dart:async';
import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
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
  });

  final int sectionId;
  final String sectionTitle;

  @override
  _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
}

bool isNeedToShowOrNot = false;

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  @override
  void initState() {
    super.initState();
    isNeedToShowOrNot = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizQuestionCubit(widget.sectionId, context),
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

            if (state.selectedIndex == null && state.showAnswer == false && state.isTimerEnded == false) {
              isNeedToShowOrNot = false;
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
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
