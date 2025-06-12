import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/Validators.dart';
import '../../Screens/Onboarding/Login/LoginScreen.dart';
import 'createNewPassword_repository.dart';
import 'createNewPassword_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordState());

  Future<void> resetPasswordApi(BuildContext context, String email) async {
    emit(state.copyWith(status: CommonApiStatus.submitting, errorMessage: null));
    try {
      await CreateNewPasswordRepository().resetPasswordApi(
        email: email,
        password: state.password,
        confirmPassword: state.confirmPassword,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  LoginScreen()),
      );
    } catch (e) {
      emit(state.copyWith(
        status: CommonApiStatus.failure,
        errorMessage: e.toString(),
      ));
    }
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
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    final newPassword = password ?? state.password;
    final newConfirmPassword = confirmPassword ?? state.confirmPassword;

    // Validate both
    final updatedPasswordError = Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
    Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid = updatedPasswordError == null &&
        updatedConfirmPasswordError == null &&
        newPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        password: newPassword,
        confirmPassword: newConfirmPassword,
        passwordError: updatedPasswordError,
        confirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
