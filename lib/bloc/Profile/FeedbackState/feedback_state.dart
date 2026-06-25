class FeedbackState {
  final int rating;
  final String comment;
  final bool isSubmitting;
  final bool submissionSuccess;

  final List<String> selectedFeedbackCategories;
  final bool showCategories;
  final List<String> categories;

  FeedbackState({
    this.rating = 0,
    this.comment = '',
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.selectedFeedbackCategories = const [],
    this.showCategories = true,
    this.categories = const [
      "App Performance",
      "Customer Support",
      "Easy to Use",
      "Content Quality",
      "Bug/Errors",
    ],
  });

  FeedbackState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    bool? submissionSuccess,
    List<String>? selectedFeedbackCategories,
    bool? showCategories,
    List<String>? categories,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,

      selectedFeedbackCategories: selectedFeedbackCategories ?? this.selectedFeedbackCategories,
      showCategories: showCategories ?? this.showCategories,
      categories: categories ?? this.categories,
    );
  }
}
