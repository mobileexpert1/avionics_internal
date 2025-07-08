class ChatHistoryModel {
  final String id;
  final String title;

  ChatHistoryModel({required this.id, required this.title});

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryModel(id: json['id'] ?? '', title: json['title'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
