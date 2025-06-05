class ChangepasswordState {
  final String oldPassword;
  final String newPassword;
  final String newConfirmPassword;
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? newConfirmPasswordError;
  final bool isButtonEnabled;

  ChangepasswordState({
    this.oldPassword = '',
    this.newPassword = '',
    this.newConfirmPassword = '',
    this.oldPasswordError,
    this.newPasswordError,
    this.newConfirmPasswordError,
    this.isButtonEnabled = false,
  });

  ChangepasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? newConfirmPassword,
    String? oldPasswordError,
    String? newPasswordError,
    String? newConfirmPasswordError,
    bool? isButtonEnabled,
  }) {
    return ChangepasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      newConfirmPassword: newConfirmPassword ?? this.newConfirmPassword,
      oldPasswordError: oldPasswordError ?? this.oldPasswordError,
      newPasswordError: newPasswordError ?? this.newPasswordError,
      newConfirmPasswordError: newConfirmPasswordError ?? this.newConfirmPasswordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
