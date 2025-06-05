import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Constants/Validators.dart';
import 'changePassword_state.dart';

class ChangePasswordCubit extends Cubit<ChangepasswordState> {
  ChangePasswordCubit() : super(ChangepasswordState());

  void oldPasswordChanged(String password) {
    final error = Validators().validatePassword(password);
    _emitUpdatedState(oldPassword: password, oldPasswordError: error);
  }

  void newPasswordChanged(String password) {
    final error = Validators().validatePassword(password);
    _emitUpdatedState(newPassword: password, newPasswordError: error);
  }

  void confirmPasswordChanged(String confirmPassword) {
    final error = Validators().validateConfirmPassword(
      state.newPassword,
      confirmPassword,
    );
    _emitUpdatedState(
      newConfirmPassword: confirmPassword,
      newConfirmPasswordError: error,
    );
  }

  void _emitUpdatedState({
    String? oldPassword,
    String? newPassword,
    String? newConfirmPassword,
    String? oldPasswordError,
    String? newPasswordError,
    String? newConfirmPasswordError,
  }) {
    final updatedOldPassword = oldPassword ?? state.oldPassword;
    final updatedNewPassword = newPassword ?? state.newPassword;
    final updatedConfirmPassword = newConfirmPassword ?? state.newConfirmPassword;

    final updatedOldPasswordError =
        oldPasswordError ?? Validators().validatePassword(updatedOldPassword);

    final updatedNewPasswordError =
        newPasswordError ?? Validators().validatePassword(updatedNewPassword);

    final updatedConfirmPasswordError = newConfirmPasswordError ??
        Validators().validateConfirmPassword(updatedNewPassword, updatedConfirmPassword);

    final isValid =
        updatedOldPasswordError == null &&
            updatedNewPasswordError == null &&
            updatedConfirmPasswordError == null &&
            updatedOldPassword.isNotEmpty &&
            updatedNewPassword.isNotEmpty &&
            updatedConfirmPassword.isNotEmpty;

    emit(
      state.copyWith(
        oldPassword: updatedOldPassword,
        newPassword: updatedNewPassword,
        newConfirmPassword: updatedConfirmPassword,
        oldPasswordError: updatedOldPasswordError,
        newPasswordError: updatedNewPasswordError,
        newConfirmPasswordError: updatedConfirmPasswordError,
        isButtonEnabled: isValid,
      ),
    );
  }
}
