// lib/bloc/signup/signup_state.dart
class SignupState {
  final String email;
  final String password;
  final String confirmPassword;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool isButtonEnabled;

  SignupState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.isButtonEnabled = false,
  });

  SignupState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    bool? isButtonEnabled,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
