import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import 'chat_history_model.dart';
import 'chat_history_repository.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  ChatHistoryCubit() : super(ChatHistoryState());

  Future<void> fetchChatHistory(context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );

    try {
      final List<ChatHistoryModel> chatList = await ChatHistoryRepository()
          .fetchChatHistory();
      emit(state.copyWith(status: CommonApiStatus.success, chatList: chatList));
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

  Future<void> loadChatHistory(BuildContext context) async {
    emit(state.copyWith(
      isLoading: true,
      status: CommonApiStatus.submitting,
      errorMessage: null,
    ));

    try {
      final response = await ChatHistoryRepository().fetchChatHistory1();

      emit(state.copyWith(
        isLoading: false,
        status: CommonApiStatus.success,
        chatList: response.data,
      ));
    } catch (e) {
      SessionCommonTokenError.handleUnauthorizedError(context, e);

      emit(state.copyWith(
        isLoading: false,
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

}


