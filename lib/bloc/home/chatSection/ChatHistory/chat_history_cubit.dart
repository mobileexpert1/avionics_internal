import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'chat_history_model.dart';
import 'chat_history_repository.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  ChatHistoryCubit() : super(ChatHistoryState());

  // Future<void> fetchChatHistory(context) async {
  //   emit(
  //     state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
  //   );
  //
  //   try {
  //     final List<ChatHistoryModel> chatList = await ChatHistoryRepository()
  //         .fetchChatHistory();
  //     emit(state.copyWith(status: CommonApiStatus.success, chatList: chatList));
  //   } catch (e) {
  //     SessionCommonTokenError.handleUnauthorizedError(context, e);
  //     emit(
  //       state.copyWith(
  //         status: CommonApiStatus.failure,
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }

  Future<void> loadChatHistory({
    required BuildContext context,
    int? page,
    bool isLoadMore = false,
  }) async {
    final nextPage = page ?? (isLoadMore ? state.currentPage + 1 : 1);

    if (isLoadMore) {
      emit(state.copyWith(isFetchingMore: true));
    } else {
      emit(
        state.copyWith(
          isLoading: true,
          currentPage: 1,
          chatList: [],
          errorMessage: null,
        ),
      );
    }

    try {
      final paginated = await ChatHistoryRepository().getChatHistory(
        page: nextPage,
      );

      final updatedList = isLoadMore
          ? [...state.chatList, ...paginated.results]
          : paginated.results;

      emit(
        state.copyWith(
          chatList: updatedList,
          currentPage: paginated.currentPage,
          hasNextPage: paginated.hasNext,
          isLoading: false,
          isFetchingMore: false,
          status: CommonApiStatus.success,
        ),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          isLoading: false,
          isFetchingMore: false,
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteSession(BuildContext context, String sessionId) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );

    try {
      await ChatHistoryRepository().deleteChatSession(sessionId);
      await ChatHistoryRepository().deleteLocalSession(sessionId);

      final updatedList = List<ChatHistoryModel>.from(state.chatList)
        ..removeWhere((item) => item.id == sessionId);

      emit(
        state.copyWith(chatList: updatedList, status: CommonApiStatus.success),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateSessionTitle(
    BuildContext context, {
    required String sessionId,
    required String newTitle,
  }) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );

    try {
      await ChatHistoryRepository().updateChatTitle(
        sessionId: sessionId,
        newTitle: newTitle,
      );

      final updatedList = state.chatList.map((item) {
        if (item.id == sessionId) {
          return item.copyWith(title: newTitle);
        }
        return item;
      }).toList();

      emit(
        state.copyWith(chatList: updatedList, status: CommonApiStatus.success),
      );
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
