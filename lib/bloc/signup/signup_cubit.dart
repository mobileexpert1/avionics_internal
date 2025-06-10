import 'package:avionics_internal/Onboarding/Otp/OtpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiErrorModel.dart';
import 'signup_repository.dart';
import 'signup_state.dart';
import '../../Constants/Validators.dart';
import '../../Subscription/SubscriptionScreen.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  Future<void> submitSignupApi(BuildContext context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await SignupRepository().register(
        first_name: state.firstName,
        last_name: state.lastName,
        email: state.email,
        password: state.password,
        username: state.firstName + state.lastName,
        phone_number: '',
        professional_role: '',
        experience_level: '',
        user_type: 'student',
        auth_type: '',
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      // Navigate after emitting success state
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: state.email, isComeFromSignup: true),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommonApiStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void firstNameChanged(String firstName) {
    final error = Validators().validateName(firstName);
    _emitUpdatedState(firstName: firstName, firstNameError: error);
  }

  void lastNameChanged(String lastName) {
    final error = Validators().validateName(lastName);
    _emitUpdatedState(lastName: lastName, lastNameError: error);
  }

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
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    final newFirstName = firstName ?? state.firstName;
    final newLastName = lastName ?? state.lastName;
    final newEmail = email ?? state.email;
    final newPassword = password ?? state.password;
    final newConfirmPassword = confirmPassword ?? state.confirmPassword;

    final updatedFirstNameError =
        firstNameError ?? Validators().validateName(newFirstName);
    final updatedLastNameError =
        lastNameError ?? Validators().validateName(newLastName);
    final updatedEmailError =
        emailError ?? Validators().validateEmail(newEmail);
    final updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
        confirmPasswordError ??
        Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid =
        updatedFirstNameError == null &&
        updatedLastNameError == null &&
        updatedEmailError == null &&
        updatedPasswordError == null &&
        updatedConfirmPasswordError == null &&
        newFirstName.isNotEmpty &&
        newLastName.isNotEmpty &&
        newEmail.isNotEmpty &&
        newPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        firstName: newFirstName,
        lastName: newLastName,
        email: newEmail,
        password: newPassword,
        confirmPassword: newConfirmPassword,
        firstNameError: updatedFirstNameError,
        lastNameError: updatedLastNameError,
        emailError: updatedEmailError,
        passwordError: updatedPasswordError,
        confirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
