class ManageAccState {
  final String firstName;
  final String lastName;
  final String email;

  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;

  final bool isButtonEnabled;

  ManageAccState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.isButtonEnabled = false,
  });

  ManageAccState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    bool? isButtonEnabled,
  }) {
    return ManageAccState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,

      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,

      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
