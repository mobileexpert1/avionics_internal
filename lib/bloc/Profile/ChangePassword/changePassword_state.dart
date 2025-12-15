import '../../../Constants/ApiClass/ApiErrorModel.dart';

class ChangeNewPasswordState {
  final String oldPassword;
  final String password;
  final String confirmPassword;
  final String? oldPasswordError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isButtonEnabled;

  final bool isLoading;
  final bool isSuccess;
  final String? apiError;
  final CommonApiStatus status;
  final String? errorMessage;

  ChangeNewPasswordState({
    this.oldPassword = '',
    this.password = '',
    this.confirmPassword = '',
    this.oldPasswordError,
    this.passwordError,
    this.confirmPasswordError,
    this.isButtonEnabled = false,

    this.isLoading = false,
    this.isSuccess = false,
    this.apiError,
    this.status = CommonApiStatus.initial,
    this.errorMessage,
  });

  ChangeNewPasswordState copyWith({
    String? oldPassword,
    String? password,
    String? confirmPassword,
    String? oldPasswordError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isButtonEnabled,

    bool? isLoading,
    bool? isSuccess,
    String? apiError,
    CommonApiStatus? status,
    String? errorMessage,
  }) {
    return ChangeNewPasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      oldPasswordError: oldPasswordError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,


      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      apiError: apiError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
