class ForgotState {
  final String email;
  final String? emailError;
  final bool isButtonEnabled;

  ForgotState({this.email = '', this.emailError, this.isButtonEnabled = false});

  ForgotState copyWith({
    String? email,
    String? emailError,
    bool? isButtonEnabled,
  }) {
    return ForgotState(
      email: email ?? this.email,
      emailError: emailError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
