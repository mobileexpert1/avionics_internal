// feedback_state.dart
class FeedbackState {
  final int rating;
  final String comment;
  final bool isSubmitting;

  FeedbackState({
    this.rating = 0,
    this.comment = '',
    this.isSubmitting = false,
  });

  FeedbackState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
