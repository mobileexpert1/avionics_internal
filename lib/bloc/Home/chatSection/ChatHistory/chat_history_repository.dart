// import 'package:collection/collection.dart';
// import '../../../../Database/generic_methods.dart';
// import '../ChatBot/chat_model.dart';
// import 'chat_history_model.dart';
//
// class ChatHistoryRepository {
//   final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);
//
//   Future<List<ChatHistoryModel>> fetchChatHistory() async {
//     try {
//       final messages = await _chatDb.getAll('chat_messages');
//
//       final grouped = groupBy(messages, (ChatMessage msg) => msg.sessionId);
//
//       final history = grouped.entries.map((entry) {
//         final firstBotMsg = entry.value.firstWhere(
//               (msg) => msg.author == ChatAuthor.bot && msg.text.trim().isNotEmpty,
//           orElse: () => entry.value.first,
//         );
//
//         return ChatHistoryModel(
//           id: entry.key,
//           title: firstBotMsg.text,
//         );
//       }).toList();
//
//       return history;
//     } catch (e) {
//       throw 'Failed to fetch chat history from local DB: $e';
//     }
//   }
// }
//
//
//


import 'package:collection/collection.dart';
import '../../../../Database/generic_methods.dart';
import '../ChatBot/chat_model.dart';
import 'chat_history_model.dart';

class ChatHistoryRepository {
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  Future<List<ChatHistoryModel>> fetchChatHistory() async {
    try {
      final messages = await _chatDb.getAll('chat_messages');

      final grouped = groupBy(messages, (ChatMessage msg) => msg.sessionId);

      final history = grouped.entries.map((entry) {
        // Find the first non-empty message (user or bot) as the title
        final firstMessage = entry.value.firstWhere(
              (msg) => msg.text.trim().isNotEmpty,
          orElse: () => entry.value.firstOrNull ?? ChatMessage(id: '', author: ChatAuthor.bot, text: 'Untitled Chat', sessionId: entry.key),
        );

        return ChatHistoryModel(
          id: entry.key,
          title: firstMessage.text, // Use the first non-empty message
        );
      }).toList();

      return history;
    } catch (e) {
      print('Error fetching chat history: $e');
      throw 'Failed to fetch chat history from local DB: $e';
    }
  }
}
