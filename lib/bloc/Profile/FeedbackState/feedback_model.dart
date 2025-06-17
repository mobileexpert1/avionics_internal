class FeedbackModel {
  final int rating;
  final String description;

  FeedbackModel({
    required this.rating,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'description': description,
    };
  }
}
