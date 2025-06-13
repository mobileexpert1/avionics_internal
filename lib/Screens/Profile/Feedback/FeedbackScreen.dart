import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/ConstantStrings.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../CustomFiles/CustomBottomButton.dart';
import '../../../bloc/Profile/FeedbackState/feedback_cubit.dart';
import '../../../bloc/Profile/FeedbackState/feedback_state.dart';

class FeedbackScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: ConstantStrings.reviewTitle,
          leftButton: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<FeedbackCubit, FeedbackState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 80,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              size: 51,
                              color: index < state.rating
                                  ? Colors.amber
                                  : Colors.grey[300],
                            ),
                            onPressed: () {
                              final currentRating = context
                                  .read<FeedbackCubit>()
                                  .state
                                  .rating;
                              final tappedRating = index + 1;
                              context.read<FeedbackCubit>().updateRating(
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          controller: controller,
                          maxLines: 14,
                          decoration: const InputDecoration(
                            hintText: "Enter some suggestions for us...",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => context
                              .read<FeedbackCubit>()
                              .updateComment(value),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomBottomButton(
                          title: state.isSubmitting ? "" : "Submit",
                          backgroundColor: const Color.fromRGBO(
                            63,
                            61,
                            81,
                            1.0,
                          ),
                          textColor: Colors.white,
                          icon: state.isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const SizedBox(width: 0),
                          isEnabled: !state.isSubmitting,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            context.read<FeedbackCubit>().submitFeedback();
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
    );
  }
}
