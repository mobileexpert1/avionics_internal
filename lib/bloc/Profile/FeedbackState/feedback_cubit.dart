// feedback_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackState());

  void updateRating(int rating) {
    emit(state.copyWith(rating: rating));
  }

  void updateComment(String comment) {
    emit(state.copyWith(comment: comment));
  }

  void submitFeedback() {
    emit(state.copyWith(isSubmitting: true));
    // Simulate submit delay (you can call an API here)
    Future.delayed(Duration(seconds: 2), () {
      emit(state.copyWith(isSubmitting: false));
    });
  }
}
