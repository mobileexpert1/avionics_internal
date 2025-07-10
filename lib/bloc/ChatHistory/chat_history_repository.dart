import 'chat_history_model.dart';
import '../../Constants/ApiClass/api_service.dart';
import '../../Constants/ConstantStrings.dart';

class ChatHistoryRepository {
  Future<List<ChatHistoryModel>> fetchChatHistory() async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiServiceUrlConstant.chatHistorySession,
    );

    try {
      final response = await ApiService.get(url: url);

      final Map<String, dynamic> json = response;
      final List<dynamic> dataList = json['data'] ?? [];

      return dataList.map((item) => ChatHistoryModel.fromJson(item)).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}

// import '../../Database/generic_methods.dart';
// import '../ChatBot/chat_model.dart';
// import 'chat_history_model.dart';
//
// class ChatHistoryRepository {
//   final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);
//
//   Future<List<ChatHistoryModel>> fetchChatHistory() async {
//     // Get all chat messages from the local DB
//     final messages = await _chatDb.getAll('chat_messages');
//
//     // You can customize this: we are using each message's ID and first few words as title
//     final history = messages.map((msg) {
//       final preview = msg.text.length > 30
//           ? '${msg.text.substring(0, 30)}...'
//           : msg.text;
//       return ChatHistoryModel(id: msg.id, title: preview);
//     }).toList();
//
//     return history;
//   }
// }
