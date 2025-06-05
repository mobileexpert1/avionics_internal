class CreateNewPasswordState {
  final String oldPassword;
  final String password;
  final String confirmPassword;
  final String? oldPasswordError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isButtonEnabled;

  CreateNewPasswordState({
    this.oldPassword = '',
    this.password = '',
    this.confirmPassword = '',
    this.oldPasswordError,
    this.passwordError,
    this.confirmPasswordError,
    this.isButtonEnabled = false,
  });

  CreateNewPasswordState copyWith({
    String? oldPassword,
    String? password,
    String? confirmPassword,
    String? oldPasswordError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isButtonEnabled,
  }) {
    return CreateNewPasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      oldPasswordError: oldPasswordError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
