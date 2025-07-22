import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'chat_history_model.dart';
import 'package:equatable/equatable.dart';

class ChatHistoryState extends Equatable {
  final List<ChatHistoryModel> chatList;

  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const ChatHistoryState({
    this.chatList = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ChatHistoryState copyWith({
    List<ChatHistoryModel>? chatList,
    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ChatHistoryState(
      chatList: chatList ?? this.chatList,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    chatList,
    isLoading,
    isSuccess,
    apiError,
    status,
    errorMessage,
  ];
}
