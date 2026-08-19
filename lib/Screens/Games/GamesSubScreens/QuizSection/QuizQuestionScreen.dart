import 'dart:async';

import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/CustomFiles/CustomBottomButton.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_cubit.dart';
import 'package:avionics_internal/bloc/Games/QuizQuestionScreen/quiz_question_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../CustomFiles/CustomAppBar.dart';
import '../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../Helpers/CacheManger/CachedImageFile.dart';
import '../../../../Helpers/FormattedText/FormattedText.dart';
import '../../MainGameScreen/InfoWrongGameScreen.dart';

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

double imageZoomMin = 0.5;
double imageZoomMax = 5.0;
bool isNeedToShowOrNot = false;
bool isNeedToShowFlagOptions = false;

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  final ScrollController _scrollController = ScrollController();

  final TransformationController _transformationController =
      TransformationController();

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
          AnalyticsService.instance.buttonPressed(
            FirebaseEvents.quizQuestionReportButton,
            FirebaseEvents.quizMainQuestionScreen,
          );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileWeb = kIsWeb && screenWidth < 900;
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
                      icon: const Icon(Icons.flag, color: Colors.white),
                      onPressed: () async {
                        _showRadioPopup(context);
                      },
                    ),
              leftButton: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () async {
                  final cubit = context.read<QuizQuestionCubit>();
                  final gameName = cubit.returnGameName();

                  final shouldExit = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Exit $gameName"),
                      backgroundColor: Colors.white,
                      content: const Text(
                        "Are you sure you want to exit? Your progress will be lost.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await SharedPrefsHelper.clearJettingGames();
                            Navigator.of(context).pop(false);
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
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
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.blue,
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                              AppColors.separatorColourAppBar,
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

                if (state.questions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobileWeb
                            ? 10
                            : kIsWeb
                            ? 200
                            : 10,
                      ),
                      child: SingleChildScrollView(
                        key: ValueKey(state.currentIndex),
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),

                            QuizQuestionCard(
                              timeTaken: state.timeTaken,
                              hintText: state.currentQuestion.hint,
                              imgUrl: state.currentQuestion.imgUrl,
                              question: state.currentQuestion.question,
                              options: state.currentQuestion.options,
                              selectedOption: state.selectedIndex,
                              correctOption: state.currentQuestion.correctIndex,
                              isNeedToShowOrNot: isNeedToShowOrNot,
                              isShowAnswers: state.showAnswer,
                              currentQuestion: state.currentIndex + 1,
                              totalQuestions: quizCubit.maxQuestions,
                              secondsRemaining: state.timer,
                              transformationController:
                                  _transformationController,

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

                                  _transformationController.value =
                                      Matrix4.identity();
                                  if (_scrollController.hasClients) {
                                    _scrollController.jumpTo(0);
                                  }
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
                        color: Colors.black.withValues(alpha: 0.3),
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
  final String imgUrl;
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
  final TransformationController transformationController;

  const QuizQuestionCard({
    required this.timeTaken,
    required this.hintText,
    required this.imgUrl,
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
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isMobileWeb = kIsWeb && screenWidth < 900;

    final imageWidth = isMobileWeb
        ? screenWidth
        : kIsWeb
        ? screenWidth * 0.6
        : screenWidth;

    final imageHeight = isMobileWeb
        ? screenWidth * 0.6
        : kIsWeb
        ? screenWidth * 0.35
        : screenWidth * 0.6;

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
                  if (imgUrl != "") ...[
                    SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            transformationController: transformationController,
                            boundaryMargin: const EdgeInsets.all(100),
                            minScale: imageZoomMin,
                            maxScale: imageZoomMax,
                            onInteractionUpdate: (details) {
                              final scale = transformationController.value
                                  .getMaxScaleOnAxis();
                              if (scale <= 1.01) {
                                transformationController.value =
                                    Matrix4.identity();
                              }
                            },
                            child: CachedAnyImage(
                              isForPlaneList: true,
                              imagePath: imgUrl,
                              width: imageWidth,
                              height: imageHeight,
                              contentImage: kIsWeb
                                  ? BoxFit.contain
                                  : BoxFit.cover,
                            ),
                          ),

                          // ZOOM LEVEL INDICATOR
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: ValueListenableBuilder(
                              valueListenable: transformationController,
                              builder: (_, value, _) {
                                final scale = transformationController.value
                                    .getMaxScaleOnAxis();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "${scale.toStringAsFixed(1)}x",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),

                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Full preview
                                  CachedAnyImage(
                                    isForPlaneList: true,
                                    imagePath: imgUrl,
                                    width: 60,
                                    height: 40,
                                    contentImage: BoxFit.cover,
                                  ),

                                  ValueListenableBuilder(
                                    valueListenable: transformationController,
                                    builder: (_, value, _) {
                                      final matrix =
                                          transformationController.value;

                                      final scale = matrix.getMaxScaleOnAxis();
                                      final dx = matrix.storage[12];
                                      final dy = matrix.storage[13];

                                      if (scale <= 1.01) {
                                        return Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Container(
                                            width: 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors
                                                    .blackBoxColorForGame,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      double viewWidth = 60 / scale;
                                      double viewHeight = 40 / scale;

                                      return Positioned(
                                        left: (-dx / scale).clamp(
                                          0,
                                          60 - viewWidth,
                                        ),
                                        top: (-dy / scale).clamp(
                                          0,
                                          40 - viewHeight,
                                        ),
                                        child: Container(
                                          width: viewWidth,
                                          height: viewHeight,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors
                                                  .blackBoxColorForGame,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        borderColor = AppColors.blackBoxColorForGame;
                        trailingIcon = const Icon(
                          Icons.cancel,
                          color: AppColors.blackBoxColorForGame,
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
                              child: FormattedText(text: hintText),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  Center(
                    child: SizedBox(
                      width: isMobileWeb
                          ? double.infinity
                          : kIsWeb
                          ? screenWidth * 0.45
                          : double.infinity,
                      height: 48,
                      child: CustomBottomButton(
                        fontStyle: AppTextStyles.regular(21.46).copyWith(
                          height: 1.0,
                          color: selectedOption != null
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                        title: isShowAnswers == false
                            ? ConstantStrings.submitTitle
                            : ConstantStrings.next,
                        backgroundColor: AppColors.primaryDark,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  (secondsRemaining > 0 && secondsRemaining < 10)
                      ? Image.asset(
                          CommonUi.setGifAndVideoImage(
                            AssetsPath.timeoutAlertGif,
                            false,
                          ),
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.access_time,
                          size: 30,
                          color: secondsRemaining == 0
                              ? AppColors.blackBoxColorForGame
                              : Colors.blue,
                        ),

                  SizedBox(
                    width: 50,
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
              }),

              const Divider(thickness: 1, height: 1),

              if (isOtherSelected) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _otherIssueController,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 50,
                    onChanged: (value) {
                      setState(() {
                        _errorText = value.length == 50
                            ? 'Maximum 50 characters allowed'
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
                        borderSide: const BorderSide(
                          color: AppColors.blackBoxColorForGame,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.blackBoxColorForGame,
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
