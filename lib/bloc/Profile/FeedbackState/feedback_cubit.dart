import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'feedback_model.dart';
import 'feedback_state.dart';
import 'feedback_repository.dart';

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
    emit(state.copyWith(isSubmitting: true, submissionSuccess: false));

    final feedback = FeedbackModel(
      rating: state.rating,
      description: state.comment,
    );

    try {
      await repository.submitReview(feedback);
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: true,
      ));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(state.copyWith(isSubmitting: false));
    }
  }
}
