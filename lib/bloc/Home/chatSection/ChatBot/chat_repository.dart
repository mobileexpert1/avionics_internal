import 'dart:async';
import 'chat_model.dart';

abstract class ChatRepository {
  Stream<ChatMessage> get messages;
  Future<void> connect({required String accessToken});
  void send(String text);
  Future<void> dispose();
}
