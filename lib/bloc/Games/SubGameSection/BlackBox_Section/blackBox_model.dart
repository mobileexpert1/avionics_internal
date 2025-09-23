class BlackBoxSummaryModel {
  String? detail;
  String? questionNo;
  List<Data>? data;

  BlackBoxSummaryModel({this.detail, this.questionNo, this.data});

  BlackBoxSummaryModel.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    questionNo = json['question_no'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        print('Parsing Data: $v'); // Debug
        data!.add(Data.fromJson(v));
      });
    } else {
      print('No data field in JSON: $json'); // Debug
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['question_no'] = questionNo;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  String? type;

  Data({this.title, this.description, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['expantion'] ?? json['expansion']; // Handle typo or API change
    type = json['type'];
    print('Parsed Data - Title: $title, Description: $description, Type: $type'); // Debug
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['expantion'] = description;
    data['type'] = type;
    return data;
  }
}





class BlackBoxSubmitResponse {
  final String detail;
  final BlackBoxSubmitData data;

  BlackBoxSubmitResponse({required this.detail, required this.data});

  factory BlackBoxSubmitResponse.fromJson(Map<String, dynamic> json) {
    return BlackBoxSubmitResponse(
      detail: json['detail'] ?? '',
      data: BlackBoxSubmitData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'data': data.toJson(),
    };
  }
}

class BlackBoxSubmitData {
  final String game;
  final String level;
  final String difficulty;
  final double percentage;
  final int totalQuestions;
  final int correctAnswers;
  final int correctPoints;
  final int earnedPoints;
  final int additionalPoints;

  BlackBoxSubmitData({
    required this.game,
    required this.level,
    required this.difficulty,
    required this.percentage,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.correctPoints,
    required this.earnedPoints,
    required this.additionalPoints,
  });

  factory BlackBoxSubmitData.fromJson(Map<String, dynamic> json) {
    return BlackBoxSubmitData(
      game: json['game'] ?? '',
      level: json['level'] ?? '',
      difficulty: json['difficulty'] ?? '',
      percentage: (json['percentage'] != null) ? json['percentage'].toDouble() : 0.0,
      totalQuestions: json['total_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      correctPoints: json['correct_points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      additionalPoints: json['additional_points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game': game,
      'level': level,
      'difficulty': difficulty,
      'percentage': percentage,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'correct_points': correctPoints,
      'earned_points': earnedPoints,
      'additional_points': additionalPoints,
    };
  }
}
