enum SignupStatus { initial, loading, success, failure }

class SignupState {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final String userType;
  final SignupStatus status;
  final String? errorMessage;

  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final String? usernameError;
  final String? userTypeError;

  final bool isButtonEnabled;

  SignupState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.username = '',
    this.userType = '',
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.usernameError,
    this.userTypeError,
    this.isButtonEnabled = false,

    this.status = SignupStatus.initial,
    this.errorMessage,
  });

  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? username,
    String? userType,

    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? usernameError,
    String? userTypeError,

    bool? isButtonEnabled,

    SignupStatus? status,
    String? errorMessage,
  }) {
    return SignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      username: username ?? this.username,
      userType: userType ?? this.userType,

      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      usernameError: usernameError,
      userTypeError: userTypeError,

      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,

      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
