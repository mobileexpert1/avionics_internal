// import 'chat_history_model.dart';
// import '../../Constants/ApiClass/api_service.dart';
// import '../../Constants/ConstantStrings.dart';
//
// class ChatHistoryRepository {
//   Future<List<ChatHistoryModel>> fetchChatHistory() async {
//     final url = Uri.parse(
//       ApiBaseUrlConstant.baseUrl +
//           ApiServiceUrlConstant.chatHistorySession,
//     );
//
//     try {
//       final response = await ApiService.get(url: url);
//
//       final Map<String, dynamic> json = response;
//       final List<dynamic> dataList = json['data'] ?? [];
//
//       return dataList.map((item) => ChatHistoryModel.fromJson(item)).toList();
//     } catch (e) {
//       throw e.toString();
//     }
//   }
// }


import 'package:collection/collection.dart';
import '../../Database/generic_methods.dart';
import '../ChatBot/chat_model.dart';
import 'chat_history_model.dart';


class ChatHistoryRepository {
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  Future<List<ChatHistoryModel>> fetchChatHistory() async {
    try {
      final messages = await _chatDb.getAll('chat_messages');

      final grouped = groupBy(messages, (ChatMessage msg) => msg.sessionId);

      final history = grouped.entries.map((entry) {
        final firstBotMsg = entry.value.firstWhere(
              (msg) => msg.author == ChatAuthor.bot && msg.text.trim().isNotEmpty,
          orElse: () => entry.value.first,
        );

        return ChatHistoryModel(
          id: entry.key,
          title: firstBotMsg.text,
        );
      }).toList();

      return history;
    } catch (e) {
      throw 'Failed to fetch chat history from local DB: $e';
    }
  }
}



