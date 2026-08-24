import '../../../../../Constants/ApiClass/ApiErrorModel.dart';
import 'JettingChronicleModel.dart';

class JettingChronicleState {
  final ChronicleDataModel? chronicleModel;
  final bool isLoading;
  final bool isSuccess;

  final String? errorMessage;
  final String? apiError;

  final CommonApiStatus status;

  const JettingChronicleState({
    this.chronicleModel,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.apiError,
    this.status = CommonApiStatus.initial,
  });

  JettingChronicleState copyWith({
    ChronicleDataModel? chronicleModel,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? apiError,
    CommonApiStatus? status,
  }) {
    return JettingChronicleState(
      chronicleModel: chronicleModel ?? this.chronicleModel,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      apiError: apiError ?? this.apiError,
      status: status ?? this.status,
    );
  }
}
