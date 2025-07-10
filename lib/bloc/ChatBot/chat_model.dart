import '../../Database/db_helper.dart';

enum ChatAuthor {
  user,
  bot,
}

class ChatMessage extends BaseModel {
  ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.sessionId,
    this.userId,
  });

  @override
  final String id;
  final ChatAuthor author; // Now using enum
  final String text;
  final String sessionId;
  @override
  String? userId;

  @override
  String get table => 'chat_messages';

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'author': author.name, // Save as 'user' or 'bot'
    'text': text,
    'user_id': userId,
    'session_id': sessionId,
  };

  static ChatMessage fromMap(Map<String, dynamic> map) {
    final authorStr = map['author'] as String;

    return ChatMessage(
      id: map['id'] as String,
      author: ChatAuthor.values.firstWhere(
            (e) => e.name == authorStr,
        orElse: () => ChatAuthor.bot,
      ),
      text: map['text'] as String,
      sessionId: map['session_id'] as String,
      userId: map['user_id'] as String?,
    );
  }
}
