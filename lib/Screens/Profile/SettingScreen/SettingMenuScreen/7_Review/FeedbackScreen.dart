import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../../Constants/AppColors.dart';
import '../../../../../Constants/ConstantStrings.dart';
import '../../../../../Constants/constantImages.dart';
import '../../../../../CustomFiles/CustomAppBar.dart';
import '../../../../../CustomFiles/CustomBottomButton.dart';
import '../../../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../../../bloc/Profile/FeedbackState/feedback_cubit.dart';
import '../../../../../bloc/Profile/FeedbackState/feedback_state.dart';
import 'RateAppBottomSheet.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late TextEditingController controller;
  static const int maxChars = 500;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.feedbackScreen);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width > 1500
        ? 1500
        : MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => FeedbackCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: ConstantStrings.reviewTitle,
          centerTitle: false,
          leftButton: IconButton(
            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
              fit: BoxFit.cover,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: BlocListener<FeedbackCubit, FeedbackState>(
                listenWhen: (previous, current) =>
                    current.submissionSuccess && !previous.submissionSuccess,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Review submitted successfully."),
                    ),
                  );
                  //Navigator.pop(context);
                  showRateAppBottomSheet(context);
                },
                child: BlocBuilder<FeedbackCubit, FeedbackState>(
                  builder: (context, state) {
                    final textLength = controller.text.length;
                    final isEmpty = controller.text.trim().isEmpty;
                    final isAtLimit = textLength >= maxChars;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// HEADER
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "How was your experience?",
                                    style: AppTextStyles.bold(24).copyWith(
                                      color: AppColors.primaryValueColour,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Your feedback helps us improve for everyone",
                                    style: AppTextStyles.regular(
                                      14,
                                    ).copyWith(color: AppColors.grayMedium),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// STAR RATING
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.star,
                                          size: 50,
                                          color: index < state.rating
                                              ? Colors.amber
                                              : Colors.grey[300],
                                        ),
                                        onPressed: () {
                                          final currentRating = state.rating;
                                          final tappedRating = index + 1;

                                          context
                                              .read<FeedbackCubit>()
                                              .updateRating(
                                                currentRating == tappedRating
                                                    ? 0
                                                    : tappedRating,
                                              );
                                        },
                                      );
                                    }),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                if (state.rating > 0)
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child: state.rating > 0
                                        ? Text(
                                            _getRatingData(
                                              state.rating,
                                            ).$1, // text
                                            style: TextStyle(
                                              color: _getRatingData(
                                                state.rating,
                                              ).$2,
                                              // color
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// WHAT COULD BE BETTER
                            Text(
                              "What could be better?",
                              style: AppTextStyles.bold(
                                14,
                              ).copyWith(color: AppColors.primaryValueColour),
                            ),

                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (state.categories ?? const []).map((
                                label,
                              ) {
                                final isSelected = state.selectedCategories
                                    .contains(label);

                                return GestureDetector(
                                  onTap: () => context
                                      .read<FeedbackCubit>()
                                      .toggleCategory(label, context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.grayForFeedbackAndText,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      label,
                                      style: AppTextStyles.regular(14).copyWith(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.grayMedium,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 30),

                            /// ADDITIONAL INFO
                            Text(
                              "Additional Information",
                              style: AppTextStyles.bold(
                                14,
                              ).copyWith(color: AppColors.primaryValueColour),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.grayForFeedbackAndText,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  /// TEXT FIELD
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      12,
                                      12,
                                      28,
                                    ),
                                    child: TextField(
                                      style: AppTextStyles.regular(16).copyWith(
                                        height: 1.0,
                                        color: AppColors.black,
                                      ),
                                      controller: controller,
                                      maxLines: 8,
                                      maxLength: maxChars,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                          maxChars,
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        hintText:
                                            "Tell us more about your experience",

                                        border: InputBorder.none,
                                        counterText: "",
                                        hintStyle: AppTextStyles.regular(16)
                                            .copyWith(
                                              height: 1.0,
                                              color: AppColors.grayMedium,
                                            ),
                                      ),
                                      onChanged: (value) {
                                        context
                                            .read<FeedbackCubit>()
                                            .updateComment(value);
                                        setState(() {});
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 8,
                                    right: 12,
                                    child: Text(
                                      "${controller.text.length}/$maxChars",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            controller.text.length >= maxChars
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// SUBMIT BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: CustomBottomButton(
                                fontStyle: AppTextStyles.regular(21.46)
                                    .copyWith(
                                      color: !state.isSubmitting
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                title: state.isSubmitting
                                    ? ""
                                    : "Submit Review",
                                backgroundColor: AppColors.primaryValueColour,
                                textColor: Colors.white,
                                icon: state.isSubmitting
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const SizedBox(),
                                isEnabled: !state.isSubmitting && !isEmpty,
                                onPressed: () {
                                  if (isEmpty) return;

                                  FocusManager.instance.primaryFocus?.unfocus();

                                  context.read<FeedbackCubit>().submitFeedback(
                                    context,
                                  );

                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.submitReviewsButton,
                                    FirebaseEvents.feedbackScreen,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  (String, Color) _getRatingData(int rating) {
    switch (rating) {
      case 1:
        return ("Poor", Colors.red);
      case 2:
        return ("Bad", Colors.orange);
      case 3:
        return ("Average", Colors.amber);
      case 4:
        return ("Good", Colors.lightGreen);
      case 5:
        return ("Excellent", Colors.green);
      default:
        return ("", Colors.grey);
    }
  }

  void showRateAppBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return RateAppBottomSheet(
          onRate: () {
            Navigator.pop(context);
          },
          onMaybeLater: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
