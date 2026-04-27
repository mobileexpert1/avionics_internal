class FeedbackState {
  final int rating;
  final String comment;
  final bool isSubmitting;
  final bool submissionSuccess;

  final List<String> selectedCategories;
  final bool showCategories;
  final List<String> categories;

  FeedbackState({
    this.rating = 0,
    this.comment = '',
    this.isSubmitting = false,
    this.submissionSuccess = false,
    this.selectedCategories = const [],
    this.showCategories = true,
    this.categories = const [
      "Passenger",
      "Military and Government",
      "Cargo",
      "General Aviation","Jets"
    ],
  });

  FeedbackState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    bool? submissionSuccess,
    List<String>? selectedCategories,
    bool? showCategories,
    List<String>? categories,
  }) {
    return FeedbackState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,

      selectedCategories: selectedCategories ?? this.selectedCategories,
      showCategories: showCategories ?? this.showCategories,
      categories: categories ?? this.categories,

    );
  }
}
