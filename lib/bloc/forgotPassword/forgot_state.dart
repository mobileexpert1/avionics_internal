import '../../Constants/ApiClass/ApiErrorModel.dart';

class ForgotState {
  final String email;
  final String? emailError;
  final bool isButtonEnabled;

  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  ForgotState({
    this.email = '',
    this.emailError,
    this.isButtonEnabled = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ForgotState copyWith({
    String? email,
    String? emailError,
    bool? isButtonEnabled,

    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ForgotState(
      email: email ?? this.email,
      emailError: emailError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,

      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
