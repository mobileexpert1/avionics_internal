import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../Constants/ApiClass/SessionTokenClass/session_Common_Token_Error.dart';
import '../../../Constants/Validators.dart';
import 'changePassword_repository.dart';
import 'changePassword_state.dart';

class ChangePasswordCubit extends Cubit<ChangeNewPasswordState> {
  ChangePasswordCubit() : super(ChangeNewPasswordState());

  void oldPasswordChanged(String oldPassword) {
    final isAllFilled =
        oldPassword.isNotEmpty &&
            state.password.isNotEmpty &&
            state.confirmPassword.isNotEmpty;

    emit(
      state.copyWith(oldPassword: oldPassword, isButtonEnabled: isAllFilled),
    );
  }

  void newPasswordChanged(String password) {
    final isAllFilled =
        state.oldPassword.isNotEmpty &&
            password.isNotEmpty &&
            state.confirmPassword.isNotEmpty;

    emit(state.copyWith(password: password, isButtonEnabled: isAllFilled));
  }

  void confirmPasswordChanged(String confirmPassword) {
    final isAllFilled =
        state.oldPassword.isNotEmpty &&
            state.password.isNotEmpty &&
            confirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isButtonEnabled: isAllFilled,
      ),
    );
  }

  /// 🔍 Validates fields and returns true if valid, false otherwise.
  bool validateFields() {
    final oldPasswordError = Validators().validatePassword(state.oldPassword);
    final passwordError = Validators().validatePassword(state.password);
    final confirmPasswordError = Validators().validateConfirmPassword(
      state.password,
      state.confirmPassword,
    );

    final isValid =
        oldPasswordError == null &&
            passwordError == null &&
            confirmPasswordError == null;

    emit(
      state.copyWith(
        oldPasswordError: oldPasswordError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ),
    );

    return isValid;
  }

  Future<void> submitIfValid(BuildContext context) async {
    if (validateFields()) {
      await forgotUserApi(context);
    }
  }

  Future<void> forgotUserApi(BuildContext context) async {
    emit(
      state.copyWith(status: CommonApiStatus.submitting, errorMessage: null),
    );
    try {
      await ChangePasswordRepository().changeCurrentPassword(
        oldPassword: state.oldPassword,
        newPassword: state.password,
        confirmPassword: state.confirmPassword,
      );

      emit(state.copyWith(status: CommonApiStatus.success));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your password has been changed successfully.')),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
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
  }
}
