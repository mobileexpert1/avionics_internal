class ChatSessionResponse {
  final String details;
  final List<ChatHistoryModel> data;

  ChatSessionResponse({required this.details, required this.data});

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) {
    return ChatSessionResponse(
      details: json['details'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChatHistoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'details': details, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class ChatHistoryModel {
  final String id;
  final String title;

  ChatHistoryModel({required this.id, required this.title});

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(id: json['id'] ?? '', title: json['title'] ?? '');
  }

  ChatHistoryModel copyWith({
    String? id,
    String? title,
  }) {
    return ChatHistoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
  // Map<String, dynamic> toJson() => {'id': id, 'title': title};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
