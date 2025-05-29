// lib/bloc/signup/signup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_state.dart';
import '../../Constants/Validators.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  void emailChanged(String email) {
    final error = Validators().validateEmail(email);
    _emitUpdatedState(email: email, emailError: error);
  }

  void passwordChanged(String password) {
    final error = Validators().validatePassword(password);
    _emitUpdatedState(password: password, passwordError: error);
  }

  void confirmPasswordChanged(String confirmPassword) {
    final error = Validators().validateConfirmPassword(
      state.password,
      confirmPassword,
    );
    _emitUpdatedState(
      confirmPassword: confirmPassword,
      confirmPasswordError: error,
    );
  }

  void _emitUpdatedState({
    String? email,
    String? password,
    String? confirmPassword,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    final newEmail = email ?? state.email;
    final newPassword = password ?? state.password;
    final newConfirmPassword = confirmPassword ?? state.confirmPassword;

    // Revalidate each field if its error is not explicitly passed
    final updatedEmailError =
        emailError ?? Validators().validateEmail(newEmail);
    final updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
        confirmPasswordError ??
        Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid =
        updatedEmailError == null &&
        updatedPasswordError == null &&
        updatedConfirmPasswordError == null &&
        newEmail.isNotEmpty &&
        newPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        email: newEmail,
        password: newPassword,
        confirmPassword: newConfirmPassword,
        emailError: updatedEmailError,
        passwordError: updatedPasswordError,
        confirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
