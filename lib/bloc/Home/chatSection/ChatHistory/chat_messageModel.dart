import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../ChatBot/chat_model.dart';

class ChatMessageModel {
  final String id;
  final String role;
  final String content;
  final int tokens;

  ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.tokens,
  });

  static String generateStableId({
    required String sessionId,
    required String role,
    required String content,
  }) {
    final raw = "$sessionId|$role|$content";
    return md5.convert(utf8.encode(raw)).toString();
  }

  factory ChatMessageModel.fromApi(
      Map<String, dynamic> json, String sessionId) {
    final role = json['role'] ?? '';
    final content = json['content'] ?? '';

    return ChatMessageModel(
      id: generateStableId(sessionId: sessionId, role: role, content: content),
      role: role,
      content: content,
      tokens: json['tokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'tokens': tokens
  };
}

extension ApiToDb on ChatMessageModel {
  ChatMessage toDb(String sessionId, String userId) {
    return ChatMessage(
      id: id,
      author: role == "user" ? ChatAuthor.user : ChatAuthor.bot,
      text: content,
      sessionId: sessionId,
      userId: userId,
    );
  }
}