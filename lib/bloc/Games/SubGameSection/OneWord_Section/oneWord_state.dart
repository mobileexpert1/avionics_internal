import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../Quiz_Section/quiz_model.dart';
import 'oneWord_model.dart';

class OneWordTopicState {
  final OneWordTopicModel? oneWordTopic;
  final List<quizItem> games;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? apiError;
  final CommonApiStatus status;

  const OneWordTopicState({
    this.oneWordTopic,
    this.games = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  OneWordTopicState copyWith({
    OneWordTopicModel? oneWordTopic,
    List<quizItem>? games,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return OneWordTopicState(
      oneWordTopic: oneWordTopic ?? this.oneWordTopic,
      games: games ?? this.games,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}
