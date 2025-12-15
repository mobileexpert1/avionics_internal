import 'dart:math';

import 'package:collection/collection.dart';
import '../../../../Constants/ApiClass/api_service.dart';
import '../../../../Constants/ApiClass/baseDetailResponseModel.dart';
import '../../../../Constants/ConstantStrings.dart';
import '../../../../CustomFiles/Custom_Pagination.dart';
import '../../../../Database/generic_methods.dart';
import '../ChatBot/chat_model.dart';
import 'chat_history_model.dart';

class ChatHistoryRepository {
  final _chatDb = GenericMethods<ChatMessage>(ChatMessage.fromMap);

  Future<List<ChatHistoryModel>>  fetchChatHistory() async {
    try {
      final messages = await _chatDb.getAll('chat_messages');

      final grouped = groupBy(messages, (ChatMessage msg) => msg.sessionId);

      final history = grouped.entries.map((entry) {
        final conversation = entry.value.where((msg) => msg.text.trim().isNotEmpty).toList();
        String? firstUserMessage;
        String? lastBotResponse;
        for (var msg in conversation) {
          if (msg.author == ChatAuthor.user && firstUserMessage == null) {
            firstUserMessage = msg.text.trim();
          } else if (msg.author == ChatAuthor.bot) {
            lastBotResponse = msg.text.trim();
          }
        }

        String title;
        if (firstUserMessage != null && lastBotResponse != null) {
          title = '$firstUserMessage - $lastBotResponse'.substring(0, min(50, '$firstUserMessage - $lastBotResponse'.length));
        } else if (firstUserMessage != null) {
          title = firstUserMessage.substring(0, min(50, firstUserMessage.length));
        } else if (lastBotResponse != null) {
          title = lastBotResponse.substring(0, min(50, lastBotResponse.length));
        } else {
          title = 'Untitled Chat';
        }

        return ChatHistoryModel(
          id: entry.key,
          title: title,
        );
      }).toList();

      return history;
    } catch (e) {
      print('Error fetching chat history: $e');
      throw 'Failed to fetch chat history from local DB: $e';
    }
  }

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
      ApiBaseUrlConstant.baseUrl +
          ApiFunctionUrlChatConstant.chatService +
          "/$sessionId",
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
