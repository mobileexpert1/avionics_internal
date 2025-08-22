class OneWordTopicModel {
  final String detail;
  final List<OneWord> data;

  OneWordTopicModel({
    required this.detail,
    required this.data,
  });

  factory OneWordTopicModel.fromJson(Map<String, dynamic> json) {
    return OneWordTopicModel(
      detail: json['detail'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => OneWord.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class OneWord {
  final String name;
  final int gameNumber;

  OneWord({
    required this.name,
    required this.gameNumber,
  });

  factory OneWord.fromJson(Map<String, dynamic> json) {
    return OneWord(
      name: json['name'] ?? '',
      gameNumber: json['game_number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'game_number': gameNumber,
    };
  }
}
