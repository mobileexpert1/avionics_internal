class LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isButtonEnabled;

  LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isButtonEnabled = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isButtonEnabled,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
