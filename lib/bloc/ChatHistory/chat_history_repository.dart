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
