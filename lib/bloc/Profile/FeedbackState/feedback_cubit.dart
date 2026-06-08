import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Helpers/NoInternetDialog.dart';
import 'feedback_model.dart';
import 'feedback_repository.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository repository = FeedbackRepository();

  FeedbackCubit() : super(FeedbackState());

  void updateRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void updateComment(String comment) {
    emit(state.copyWith(comment: comment));
  }

  Future<void> submitFeedback(BuildContext context) async {
    if (await InternetConnection().hasInternetAccess) {
      emit(state.copyWith(isSubmitting: true, submissionSuccess: false));

      final feedback = FeedbackModel(
        rating: state.rating,
        description: state.comment,
      );

      try {
        await repository.submitReview(feedback);
        emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);

        emit(state.copyWith(isSubmitting: false));
      }
    } else {
      NoInternetDialog.show(context, onRetry: () => submitFeedback(context));
    }
  }

  void toggleCategory(String category, BuildContext context) {
    final updated = List<String>.from(state.selectedCategories);

    if (updated.contains(category)) {
      updated.remove(category);
    } else {
      updated.add(category);
    }
    emit(state.copyWith(selectedCategories: updated));
  }

  void toggleCategoriesSection() {
    emit(state.copyWith(showCategories: !state.showCategories));
  }
}
