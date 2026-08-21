import '../../../Profile/AirPlanePartsSection/AirPlanePartsModel.dart';
import '../JettingAroundTheWorld/jettingTheWorld_model.dart';

class SubmitCalculationResultResponse {
  final String detail;
  final SubmitCalculationResultData data;

  SubmitCalculationResultResponse({required this.detail, required this.data});

  factory SubmitCalculationResultResponse.fromJson(Map<String, dynamic> json) {
    return SubmitCalculationResultResponse(
      detail: json['detail'] ?? 'No detail provided',
      data: SubmitCalculationResultData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'detail': detail, 'data': data.toJson()};
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

  final bool componentEarned;
  final AirPlaneSubPartModel? component;

  final bool partUnlock;
  final PlaneSpotterPart? part;

  final UnlockAirportModel? unlockAirport;

  final bool allUnlock;

  SubmitCalculationResultData({
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.correctPoints,
    required this.earnedPoints,
    required this.additionalPoints,
    required this.isEarnedBadge,
    required this.badgeName,
    required this.componentEarned,
    this.component,
    required this.partUnlock,
    this.part,
    this.unlockAirport,
    required this.allUnlock,
  });

  factory SubmitCalculationResultData.fromJson(Map<String, dynamic> json) {
    final componentJson = json['unlock_component'];
    final partJson = json['unlock_part'];
    final airportJson = json['unlock_airport'];

    return SubmitCalculationResultData(
      percentage: (json['percentage'] ?? 0).toDouble(),
      totalQuestions: json['total_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      correctPoints: json['correct_points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      additionalPoints: json['additional_points'] ?? 0,
      isEarnedBadge: json['is_earned_badge'] ?? false,
      badgeName: json['badge_name'] ?? '',

      componentEarned: json['component_earned'] ?? false,

      component: componentJson != null
          ? AirPlaneSubPartModel(
              id: componentJson['id'] ?? '',
              name: componentJson['title'] ?? '',
              description: componentJson['description'] ?? '',
            )
          : null,

      partUnlock: json['part_unlock'] ?? false,

      part: partJson != null
          ? PlaneSpotterPart.fromJson(partJson as Map<String, dynamic>)
          : null,

      unlockAirport: airportJson != null
          ? UnlockAirportModel.fromJson(airportJson as Map<String, dynamic>)
          : null,

      allUnlock: json['all_unlock'] ?? false,
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

    'component_earned': componentEarned,
    'unlock_component': component == null
        ? null
        : {
            'id': component!.id,
            'title': component!.name,
            'description': component!.description,
            'unlocked': true,
          },

    'part_unlock': partUnlock,
    'unlock_part': part?.toJson(),

    'unlock_airport': unlockAirport?.toJson(),
    'all_unlock': allUnlock,
  };
}

class UnlockAirportModel {
  final AirportPerItemModel? preUnblock;
  final AirportPerItemModel? newUnblock;

  UnlockAirportModel({this.preUnblock, this.newUnblock});

  factory UnlockAirportModel.fromJson(Map<String, dynamic> json) {
    return UnlockAirportModel(
      preUnblock: json['pre_unblock'] != null
          ? AirportPerItemModel.fromJson(json['pre_unblock'])
          : null,
      newUnblock: json['new_unblock'] != null
          ? AirportPerItemModel.fromJson(json['new_unblock'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pre_unblock': preUnblock?.toJson(),
      'new_unblock': newUnblock?.toJson(),
    };
  }
}
