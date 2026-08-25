class BlackBoxSummaryModel {
  String? detail;
  String? summarySetId;
  List<Data>? data;

  BlackBoxSummaryModel({this.detail, this.summarySetId, this.data});

  BlackBoxSummaryModel.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    summarySetId = json['set_id'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    } else {
      print('No data field in JSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detail'] = detail;
    data['set_id'] = summarySetId;
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
    description = json['expantion'] ?? json['expansion'];
    type = json['type'];
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
    return {'detail': detail, 'data': data.toJson()};
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
  final bool? isStickerUnlock;
  final StickerAircraftModel? stickerAircraftModel;

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
    this.isStickerUnlock,
    this.stickerAircraftModel,
  });

  factory BlackBoxSubmitData.fromJson(Map<String, dynamic> json) {
    return BlackBoxSubmitData(
      game: json['game'] ?? '',
      level: json['level'] ?? '',
      difficulty: json['difficulty'] ?? '',
      percentage: (json['percentage'] != null)
          ? json['percentage'].toDouble()
          : 0.0,
      totalQuestions: json['total_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      correctPoints: json['correct_points'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      additionalPoints: json['additional_points'] ?? 0,
      isStickerUnlock: json['is_sticker_unlock'] ?? false,
      stickerAircraftModel: StickerAircraftModel.fromJson(json['unlock_sticker_aircraft'] ?? {}),
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
      'is_sticker_unlock': isStickerUnlock,
      'unlock_sticker_aircraft':  stickerAircraftModel,
    };
  }
}

class BlackBoxTopicResponse {
  final String detail;
  final List<BlackBoxTopicModel> data;

  BlackBoxTopicResponse({required this.detail, required this.data});

  factory BlackBoxTopicResponse.fromJson(Map<String, dynamic> json) {
    return BlackBoxTopicResponse(
      detail: json['detail'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BlackBoxTopicModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'detail': detail, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class BlackBoxTopicModel {
  final String id;
  final String name;
  final int gameNumber;
  final bool isEnable;
  final List<String> info;

  BlackBoxTopicModel({
    required this.id,
    required this.name,
    required this.gameNumber,
    required this.isEnable,
    required this.info,
  });

  factory BlackBoxTopicModel.fromJson(Map<String, dynamic> json) {
    return BlackBoxTopicModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gameNumber: json['game_number'] ?? 0,
      isEnable: json['is_enable'] ?? false,
      info: List<String>.from(json['info'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'game_number': gameNumber,
      'is_enable': isEnable,
      'info': info,
    };
  }
}

class StickerAircraftModel {
  final String stickerId;
  final String modelName;
  final String icaoCode;
  final String imageName;
  final String orderChar;
  final String categoryName;

  StickerAircraftModel({
    required this.stickerId,
    required this.modelName,
    required this.icaoCode,
    required this.imageName,
    required this.orderChar,
    required this.categoryName,
  });

  factory StickerAircraftModel.fromJson(Map<String, dynamic> json) {
    return StickerAircraftModel(
      stickerId: json['sticker_id'] ?? '',
      modelName: json['model'] ?? '',
      icaoCode: json['icao_code'] ?? '',
      imageName: json['image'] ?? '',
      orderChar: json['order_char'] ?? '',
      categoryName: json['sticker_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sticker_id': stickerId,
      'model': modelName,
      'icao_code': icaoCode,
      'image': imageName,
      'order_char': orderChar,
      'sticker_name': categoryName,
    };
  }
}
