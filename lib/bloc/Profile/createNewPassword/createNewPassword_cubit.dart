import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/Validators.dart';
import '../../../Helpers/AppNavigator.dart';
import '../../../Helpers/NoInternetDialog.dart';
import '../../../Screens/Onboarding/Login/LoginScreen.dart';
import 'createNewPassword_repository.dart';
import 'createNewPassword_state.dart';

class CreateNewPasswordCubit extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordCubit() : super(CreateNewPasswordState());

  void passwordChanged(String password) {
    final isButtonEnabled =
        password.isNotEmpty && state.confirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        password: password,
        isButtonEnabled: isButtonEnabled,
        passwordError: null,
      ),
    );
  }

  void confirmPasswordChanged(String confirmPassword) {
    final isButtonEnabled =
        confirmPassword.isNotEmpty && state.password.isNotEmpty;

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isButtonEnabled: isButtonEnabled,
        confirmPasswordError: null,
      ),
    );
  }

  void validateAndSubmit(BuildContext context, String email) {
    final passwordError = Validators().validatePassword(state.password);
    final confirmPasswordError = Validators().validateConfirmPassword(
      state.password,
      state.confirmPassword,
    );

    final hasError = passwordError != null || confirmPasswordError != null;

    emit(
      state.copyWith(
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ),
    );

    if (hasError) return;

    resetPasswordApi(context, email);
  }

  Future<void> resetPasswordApi(BuildContext context, String email) async {
    if (await InternetConnection().hasInternetAccess) {
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your password has been reset successfully. Please log in again.',
            ),
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          AppNavigator.pushReplacement(
            context,
            LoginScreen(),
            disableSwipeBack: true,
          );
        });
      } catch (e) {
        SessionCommonTokenError.handleUnauthorizedError(context, e);
        emit(
          state.copyWith(
            status: CommonApiStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => resetPasswordApi(context, email),
      );
    }
  }
}
