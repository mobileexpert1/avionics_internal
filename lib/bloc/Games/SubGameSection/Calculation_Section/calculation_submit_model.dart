// class SubmitCalculationResultResponse {
//   final String detail;
//   final SubmitCalculationResultData data;
//
//   SubmitCalculationResultResponse({
//     required this.detail,
//     required this.data,
//   });
//
//   factory SubmitCalculationResultResponse.fromJson(Map<String, dynamic> json) {
//     return SubmitCalculationResultResponse(
//       detail: json['detail'] ?? '',
//       data: SubmitCalculationResultData.fromJson(json['data'] ?? {}),
//     );
//   }
// }

class SubmitCalculationResultResponse {
  final String detail;
  final Map<String, dynamic> data;

  SubmitCalculationResultResponse({
    required this.detail,
    required this.data,
  });

  factory SubmitCalculationResultResponse.fromJson(Map<String, dynamic> json) {
    return SubmitCalculationResultResponse(
      detail: json['detail'] ?? 'No detail provided',
      data: json['data'] is Map<String, dynamic> ? json['data'] : {},
    );
  }

  Map<String, dynamic> toJson() => {
    'detail': detail,
    'data': data,
  };
}

class SubmitCalculationResultData {
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int correctPoints;
  final int earnedPoints;
  final int additionalPoints;

  SubmitCalculationResultData({
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.correctPoints,
    required this.earnedPoints,
    required this.additionalPoints,
  });

  factory SubmitCalculationResultData.fromJson(Map<String, dynamic> json) {
    return SubmitCalculationResultData(
      percentage: (json['percentage'] ?? 0).toDouble(),
      totalQuestions: json['total_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      correctPoints: json['correct_points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      additionalPoints: json['additional_points'] ?? 0,
    );
  }
}
