class SubmitCalculationResultResponse {
  final String detail;
  final SubmitCalculationResultData data;

  SubmitCalculationResultResponse({
    required this.detail,
    required this.data,
  });

  factory SubmitCalculationResultResponse.fromJson(Map<String, dynamic> json) {
    return SubmitCalculationResultResponse(
      detail: json['detail'] ?? 'No detail provided',
      data: SubmitCalculationResultData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'detail': detail,
    'data': data.toJson(),
  };
}

class SubmitCalculationResultData {
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int correctPoints;
  final int earnedPoints;
  final int additionalPoints;
  final bool isEarnedBadge;
  final String badgeName;

  SubmitCalculationResultData({
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.correctPoints,
    required this.earnedPoints,
    required this.additionalPoints,
    required this.isEarnedBadge,
    required this.badgeName,
  });

  factory SubmitCalculationResultData.fromJson(Map<String, dynamic> json) {
    return SubmitCalculationResultData(
      percentage: (json['percentage'] ?? 0).toDouble(),
      totalQuestions: json['total_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      correctPoints: json['correct_points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      additionalPoints: json['additional_points'] ?? 0,
      isEarnedBadge: json['is_earned_badge'] ?? false,
      badgeName: json['badge_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'percentage': percentage,
    'total_questions': totalQuestions,
    'correct_answers': correctAnswers,
    'correct_points': correctPoints,
    'earned_points': earnedPoints,
    'additional_points': additionalPoints,
    'is_earned_badge': isEarnedBadge,
    'badge_name': badgeName,
  };
}
