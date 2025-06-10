import '../../Constants/ApiClass/ApiErrorModel.dart';

class OtpState {
  final String otp;
  final bool isButtonEnabled;

  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  OtpState({
    this.otp = '',
    this.isButtonEnabled = false,

    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  OtpState copyWith({
    String? otp,
    bool? isButtonEnabled,

    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,

      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
