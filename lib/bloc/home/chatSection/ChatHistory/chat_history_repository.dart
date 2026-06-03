import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/Custom_Pagination.dart';
import '../../../../Database/generic_methods.dart';
import '../ChatBot/chat_model.dart';
import 'chat_history_model.dart';

class ChatHistoryRepository {
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  Future<void> deleteLocalSession(String sessionId) async {
    await _chatDb.deleteBySessionId('chat_messages', sessionId);
  }

  Future<PaginatedList<ChatHistoryModel>> getChatHistory({
    int page = 1,
  }) async {
    final uri = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}"
          "${ApiFunctionUrlChatConstant.chatService}"
          "?page=$page"
    );

    try {
      final jsonData = await ApiService.get(url: uri) as Map<String, dynamic>;

      return PaginatedList.fromJson(
        json: jsonData,
        fromJson: (e) => ChatHistoryModel.fromJson(e),
        currentPage: page,
      );
    } catch (e) {
      throw e.toString();
    }
  }


  Future<BaseDetailResponseModel> deleteChatSession(String sessionId) async {
    final url = Uri.parse(
      "${ApiBaseUrlConstant.baseUrl}${ApiFunctionUrlChatConstant.chatService}/$sessionId",
    );

    try {
      final response = await ApiService.delete(url: url);
      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BaseDetailResponseModel> updateChatTitle({
    required String sessionId,
    required String newTitle,
  }) async {
    final url = Uri.parse(
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlChatConstant.chatService,
    );
    final body = {
      "session_id": sessionId,
      "title": newTitle,
    };
    try {
      final response = await ApiService.patch(
        url: url,
        body: body,
      );

      return BaseDetailResponseModel.fromJson(response);
    } catch (e) {
      throw e.toString();
    }
  }

}
