import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'chat_history_model.dart';
import 'package:equatable/equatable.dart';

import 'chat_messageModel.dart';

class ChatHistoryState extends Equatable {
  final List<ChatHistoryModel> chatList;
  final List<ChatMessageModel>? results;
  final bool isLoading;
  final bool isFetchingMore;
  final bool isSuccess;
  final int currentPage;
  final bool hasNextPage;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  const ChatHistoryState({
    this.chatList = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.isSuccess = false,
    this.currentPage = 1,
    this.hasNextPage = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
    this.results,
  });

  ChatHistoryState copyWith({
    List<ChatHistoryModel>? chatList,
    bool? isLoading,
    bool? isFetchingMore,
    bool? isSuccess,
    int? currentPage,
    bool? hasNextPage,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
    List<ChatMessageModel>? results,
  }) {
    return ChatHistoryState(
      chatList: chatList ?? this.chatList,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [
    chatList,
    isLoading,
    isFetchingMore,
    isSuccess,
    currentPage,
    hasNextPage,
    apiError,
    status,
    errorMessage,
  ];
}
