class CreateNewPasswordState {
  final String password;
  final String confirmPassword;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isButtonEnabled;

  CreateNewPasswordState({
    this.password = '',
    this.confirmPassword = '',
    this.passwordError,
    this.confirmPasswordError,
    this.isButtonEnabled = false,
  });

  CreateNewPasswordState copyWith({
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmPasswordError,
    bool? isButtonEnabled,
  }) {
    return CreateNewPasswordState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordError: passwordError ?? this.passwordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
