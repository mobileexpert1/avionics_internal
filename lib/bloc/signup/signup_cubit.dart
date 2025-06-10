import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'signup_state.dart';
import '../../Constants/Validators.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

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


  Future<void> submitSignup() async {
    emit(state.copyWith(status: SignupStatus.loading));

    final url = Uri.parse("https://avionica.csdevhub.com/user-service/docs");

    final body = {
      "first_name": state.firstName,
      "last_name": state.lastName,
      "email": state.email,
      "username": state.username,
      "password": state.password,
      "user_type": state.userType,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Signup Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        final error = jsonDecode(response.body);
        emit(state.copyWith(
          status: SignupStatus.failure,
          errorMessage: error['message'] ?? "Signup failed",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SignupStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }


}
