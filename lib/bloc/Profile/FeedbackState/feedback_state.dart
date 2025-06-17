class FeedbackState {
  final int rating;
  final String comment;
  final bool isSubmitting;
  final bool submissionSuccess;

  FeedbackState({
    this.rating = 0,
    this.comment = '',
    this.isSubmitting = false,
    this.submissionSuccess = false,
  });

  FeedbackState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    bool? submissionSuccess,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }
}
