import 'package:avionics_internal/Screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/Validators.dart';
import 'createNewPassword_repository.dart';
import 'createNewPassword_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordState());

  Future<void> resetPasswordApi(BuildContext context, String email) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await CreateNewPasswordRepository().resetPasswordApi(
        email: email,
        password: state.password,
        confirmPassword: state.confirmPassword,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      // Navigate after emitting success state
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
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

    var updatedPasswordError =
        passwordError ?? Validators().validatePassword(newPassword);
    final updatedConfirmPasswordError =
        confirmPasswordError ??
        Validators().validateConfirmPassword(newPassword, newConfirmPassword);

    final isValid =
        updatedPasswordError == null &&
        updatedConfirmPasswordError == null &&
        newPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty;


    emit(
      state.copyWith(
        password: newPassword,
        confirmPassword: newConfirmPassword,
        confirmPasswordError: updatedConfirmPasswordError,
        passwordError: updatedPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
