import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../../bloc/Profile/FeedbackState/feedback_cubit.dart';
import '../../../bloc/Profile/FeedbackState/feedback_state.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late TextEditingController controller;

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
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
                        content: Text("Review submitted successfully.")),
                  );
                  Navigator.pop(context);
                },
                child: BlocBuilder<FeedbackCubit, FeedbackState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 60,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Rating Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    size: 48,
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

                            const SizedBox(height: 30),

                            const Text(
                              "Please leave your feedback about the app",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                            /// Text Field
                            Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                controller: controller,
                                maxLines: 14,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                                decoration: const InputDecoration(
                                  hintText:
                                  "Enter some suggestions for us...",
                                  border: InputBorder.none,
                                ),
                                onChanged: context
                                    .read<FeedbackCubit>()
                                    .updateComment,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: CustomBottomButton(
                                fontStyle: AppTextStyles.regular(21.46).copyWith(
                                  height: 1.0,
                                  color: !state.isSubmitting
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                ),
                                title:
                                state.isSubmitting ? "" : "Submit",
                                backgroundColor:
                                const Color.fromRGBO(63, 61, 81, 1.0),
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
                                    : const SizedBox(width: 0),
                                isEnabled: !state.isSubmitting,
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<FeedbackCubit>()
                                      .submitFeedback(context);
                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.submitReviewsButton,
                                    FirebaseEvents.feedbackScreen,
                                  );
                                },
                              ),
                            ),
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
}
